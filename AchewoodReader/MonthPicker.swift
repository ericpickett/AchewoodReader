//
//  MonthPicker.swift
//  AchewoodReader
//
//  Created by eric on 2021/05/23.
//

import UIKit

final class MonthPicker: UIPickerView {
	var months: [ComicMonth] = [] {
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
	
	func setPickerToMonth(_ month: String) {
		if let index = months.firstIndex(where: { $0.month == month }) {
			self.selectRow(index, inComponent: 0, animated: false)
		}
	}
}

extension MonthPicker: UIPickerViewDataSource {
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		switch component {
		case 0:
			return months.count
		default:
			return 0
		}
	}
}

extension MonthPicker: UIPickerViewDelegate {
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		switch component {
		case 0:
			return months[row].month
		default:
			return nil
		}
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		guard let pickerDelegate = datePickerDelegate else { return }
		pickerDelegate.stoppedScrolling(row: row, type: .month)
	}
}

