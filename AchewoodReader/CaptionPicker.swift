//
//  CaptionPicker.swift
//  AchewoodReader
//
//  Created by eric on 2021/05/20.
//

import UIKit

class CaptionPicker: UIPickerView {
	var comicPickerDelegate: ComicPickerDelegate? = nil
	
	private let captions: [String] = {
		return comics.map { $0.caption }
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
	
	func setPickerToCaption(_ caption: String) {
		if let index = captions.firstIndex(where: { $0 == caption }) {
			self.selectRow(index, inComponent: 0, animated: false)
		}

	}
}

extension CaptionPicker: UIPickerViewDataSource {
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		captions.count
	}
}

extension CaptionPicker: UIPickerViewDelegate {
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		let caption = captions[row].isEmpty ? "N/A" : captions[row]
		return caption
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		guard let pickerDelegate = self.comicPickerDelegate else { return }
		pickerDelegate.currentSelection(captions[row], type: .caption)
	}
}
