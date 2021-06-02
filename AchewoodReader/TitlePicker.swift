//
//  TitlePicker.swift
//  AchewoodReader
//
//  Created by eric on 2021/05/20.
//

import UIKit

class TitlePicker: UIPickerView {
	var comicPickerDelegate: ComicPickerDelegate? = nil
	
	private let titles: [String] = {
		return comics.map { $0.title }
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.dataSource = self
		self.delegate = self
		self.isHidden = true
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setPickerToTitle(_ title: String) {
		if let index = titles.firstIndex(where: { $0 == title }) {
			self.selectRow(index, inComponent: 0, animated: false)
		}
	}
}

extension TitlePicker: UIPickerViewDataSource {
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		titles.count
	}
}

extension TitlePicker: UIPickerViewDelegate {
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return titles[row]
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		guard let pickerDelegate = self.comicPickerDelegate else { return }
		pickerDelegate.currentSelection(titles[row], type: .title)
	}
}
