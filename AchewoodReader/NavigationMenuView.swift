//
//  NavigationMenuView.swift
//  AchewoodReader
//
//  Created by eric on 2021/05/19.
//

import UIKit

class NavigationMenuView: UIView {
	var delegate: NavigationMenuDelegate? = nil
	private let currentPageKey = "current_page"
	
	private let titles: [String] = {
		let titles = comics
			.sorted(by: { $0.date < $1.date })
			.map { return $0.date }
		
		return titles
	}()
	
	private let captions: [String] = {
		let captions = comics
			.sorted(by: { $0.date < $1.date })
			.map { return $0.caption }
		
		return captions
	}()
	
	private let segmentedControl: UISegmentedControl = {
		let control = UISegmentedControl(items: [
			"Date",
			"Title",
			"Caption"
		])
		control.backgroundColor = .white
		control.selectedSegmentIndex = 0
		control.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
		
		return control
	}()
	
	private lazy var segmentedControlConstraints: [NSLayoutConstraint] = {
		self.segmentedControl.translatesAutoresizingMaskIntoConstraints = false
		
		return [
			self.segmentedControl.centerXAnchor.constraint(equalTo: self.centerXAnchor),
			self.segmentedControl.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
			self.segmentedControl.heightAnchor.constraint(equalToConstant: 44),
		]
	}()
	
	@objc func segmentChanged(_ sender: UISegmentedControl) {
		switch sender.selectedSegmentIndex {
		case 0:
			datePicker.isHidden = false
			titlePicker.isHidden = true
			captionPicker.isHidden = true
		case 1:
			titlePicker.isHidden = false
			datePicker.isHidden = true
			captionPicker.isHidden = true
		case 2:
			captionPicker.isHidden = false
			datePicker.isHidden = true
			titlePicker.isHidden = true
		default:
			return
		}
	}
	
	private let closeButton: UIButton = {
		let button = UIButton()
		button.setTitle("X", for: .normal)
		button.setTitleColor(.darkText, for: .normal)
		button.addTarget(self, action: #selector(closeButtonPressed(sender:)), for: .touchUpInside)
		
		return button
	}()
	
	private lazy var closeButtonConstraints: [NSLayoutConstraint] = {
		self.closeButton.translatesAutoresizingMaskIntoConstraints = false
		
		return [
			self.closeButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
			self.closeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
		]
	}()
	
	@objc func closeButtonPressed(sender: UIButton) {
		self.isHidden = true
	}
	
	private let datePicker = DatePickerView()
	
	private lazy var datePickerConstraints: [NSLayoutConstraint] = {
		datePicker.translatesAutoresizingMaskIntoConstraints = false
		
		return [
			datePicker.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
			datePicker.topAnchor.constraint(equalTo: self.segmentedControl.bottomAnchor),
			datePicker.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
			datePicker.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
		]
	}()
	
	private let titlePicker = TitlePicker()
	
	private lazy var titlePickerConstraints: [NSLayoutConstraint] = {
		titlePicker.translatesAutoresizingMaskIntoConstraints = false
		
		return [
			titlePicker.centerYAnchor.constraint(equalTo: self.centerYAnchor),
			titlePicker.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
			titlePicker.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
			
		]
	}()
	
	private let captionPicker = CaptionPicker()
	
	private lazy var captionPickerConstraints: [NSLayoutConstraint] = {
		captionPicker.translatesAutoresizingMaskIntoConstraints = false
		
		return [
			captionPicker.centerYAnchor.constraint(equalTo: self.centerYAnchor),
			captionPicker.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
			captionPicker.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
		]
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.isHidden = true
		self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
		
		datePicker.comicPickerDelegate = self
		titlePicker.comicPickerDelegate = self
		captionPicker.comicPickerDelegate = self
		
		datePicker.isHidden = false
		
		self.addSubview(segmentedControl)
		self.addSubview(closeButton)
		self.addSubview(datePicker)
		self.addSubview(titlePicker)
		self.addSubview(captionPicker)
		
		NSLayoutConstraint.activate(
			segmentedControlConstraints
			+ closeButtonConstraints
			+ datePickerConstraints
			+ titlePickerConstraints
			+ captionPickerConstraints
		)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func updateCurrentSelection() {
		let currentPageIndex = UserDefaults.standard.integer(forKey: currentPageKey)
		let currentComic = comics[currentPageIndex]
		datePicker.setPickerToDate(currentComic.date)
		titlePicker.setPickerToTitle(currentComic.title)
		captionPicker.setPickerToCaption(currentComic.caption)
	}
}

extension NavigationMenuView: ComicPickerDelegate {
	func currentSelection(_ selection: String, type: PickerType) {
		guard let delegate = self.delegate else { return }
		switch type {
		case .date:
			delegate.loadComicBy(date: selection)
		case .title:
			delegate.loadComicBy(title: selection)
		case .caption:
			delegate.loadComicBy(caption: selection)
		}
	}
}

protocol NavigationMenuDelegate {
	func loadComicBy(date: String)
	func loadComicBy(title: String)
	func loadComicBy(caption: String)
}
