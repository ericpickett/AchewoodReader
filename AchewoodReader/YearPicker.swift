//
//  YearPicker.swift
//  AchewoodReader
//
//  Created by eric on 2021/05/19.
//

import UIKit

final class YearPicker: UIPickerView {
	var years: [ComicYear] = [] {
		didSet {
			self.reloadAllComponents()
		}
	}
	
	var datePickerDelegate: DatePickerDelegate? = nil
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.dataSource = self
		self.delegate = self
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setPickerToYear(_ year: String) {
		if let index = years.firstIndex(where: { $0.year == year }) {
			self.selectRow(index, inComponent: 0, animated: false)
		}
	}
}

extension YearPicker: UIPickerViewDataSource {
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		switch component {
		case 0:
			return years.count
		default:
			return 0
		}
	}
}

extension YearPicker: UIPickerViewDelegate {
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		switch component {
		case 0:
			return years[row].year
		default:
			return nil
		}
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		guard let pickerDelegate = datePickerDelegate else { return }
		pickerDelegate.stoppedScrolling(row: row, type: .year)
	}
}

