//
//  DatePickerView.swift
//  AchewoodReader
//
//  Created by eric on 2021/05/23.
//

import UIKit

class DatePickerView: UIView {
	var comicPickerDelegate: ComicPickerDelegate? = nil
	private var yearIndex = 0
	private var monthIndex = 0
	private var dayIndex = 0
	
	private let comicDates: ComicDates = {
		var dates = ComicDates(years: [])
		for index in 0..<comics.count {
			let comic = comics[index]
			let dateComponents = comic.date.split(separator: "-").map { String($0) }
			let yearComponent = dateComponents[0]
			let monthComponent = dateComponents[1]
			let dayComponent = dateComponents[2]
			
			let day = ComicDay(day: dayComponent, title: comic.title)
			var month: ComicMonth
			var year: ComicYear
			
			if let yearIndex = dates.years.firstIndex(where: { $0.year == yearComponent }) {
				year = dates.years[yearIndex]
			} else {
				year = ComicYear(year: yearComponent, months: [])
				dates.years.append(year)
			}
			
			if let monthIndex = year.months.firstIndex(where: { $0.month == monthComponent }) {
				month = year.months[monthIndex]
			} else {
				month = ComicMonth(month: monthComponent, days: [])
				year.months.append(month)
			}
			
			month.days.append(day)
			
			let yearIndex = dates.years.firstIndex(where: { $0.year == yearComponent })!
			let monthIndex = year.months.firstIndex(where: { $0.month == monthComponent })!
			dates.years[yearIndex] = year
			dates.years[yearIndex].months[monthIndex] = month
			
		}
		return dates
	}()
	
	private lazy var hStack: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [
			yearPicker,
			monthPicker,
			dayPicker,
		])
		stack.axis = .horizontal
		stack.distribution = .fillEqually
		
		return stack
	}()
	
	private lazy var hStackConstraints: [NSLayoutConstraint] = {
		hStack.translatesAutoresizingMaskIntoConstraints = false
		
		return [
			hStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			hStack.topAnchor.constraint(equalTo: self.topAnchor),
			hStack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			hStack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
		]
	}()
	
	private lazy var yearPicker: YearPicker = {
		let picker = YearPicker()
		picker.datePickerDelegate = self
		
		return picker
	}()
	
	private lazy var  monthPicker: MonthPicker = {
		let picker = MonthPicker()
		picker.datePickerDelegate = self
		
		return picker
	}()
	
	private lazy var dayPicker: DayPicker = {
		let picker = DayPicker()
		picker.datePickerDelegate = self
		
		return picker
	}()

	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		updatePickerValues()
		
		self.addSubview(hStack)
		
		NSLayoutConstraint.activate(hStackConstraints)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func updatePickerValues() {
		if monthIndex >= comicDates.years[yearIndex].months.count {
			monthIndex = comicDates.years[yearIndex].months.count - 1
		}
		
		if dayIndex >= comicDates.years[yearIndex].months[monthIndex].days.count {
			dayIndex = comicDates.years[yearIndex].months[monthIndex].days.count - 1
		}
		
		yearPicker.years = comicDates.years
		monthPicker.months = comicDates.years[yearIndex].months
		dayPicker.days = comicDates.years[yearIndex].months[monthIndex].days
		
		guard let pickerDelegate = comicPickerDelegate else { return }
		let year = comicDates.years[yearIndex].year
		let month = comicDates.years[yearIndex].months[monthIndex].month
		let day = comicDates.years[yearIndex].months[monthIndex].days[dayIndex].day
		pickerDelegate.currentSelection("\(year)-\(month)-\(day)", type: .date)
	}
	
	func setPickerToDate(_ date: String) {
		// TODO: this sucks
		
		let dateComponents = date.split(separator: "-").map { String($0) }
		yearIndex = comicDates.years.firstIndex(where: { $0.year == dateComponents[0] })!
		monthIndex = comicDates.years[yearIndex].months.firstIndex(where: { $0.month == dateComponents[1] })!
		dayIndex = comicDates.years[yearIndex].months[monthIndex].days.firstIndex(where: { $0.day == dateComponents[2] })!
		updatePickerValues()
		
		yearPicker.selectRow(yearIndex, inComponent: 0, animated: false)
		monthPicker.selectRow(monthIndex, inComponent: 0, animated: false)
		dayPicker.selectRow(dayIndex, inComponent: 0, animated: false)
	}
}

extension DatePickerView: DatePickerDelegate {
	func stoppedScrolling(row: Int, type: DatePickerType) {
		switch type {
		case .year:
			yearIndex = row
		case .month:
			monthIndex = row
		case .day:
			dayIndex = row
		}
		
		let throttled = throttle(delay: .milliseconds(10), action: updatePickerValues)
		throttled()
	}
}


enum PickerType {
	case date
	case title
	case caption
}

enum DatePickerType {
	case year
	case month
	case day
}

struct ComicDates {
	var years: [ComicYear]
}

struct ComicYear {
	let year: String
	var months: [ComicMonth]
}

struct ComicMonth {
	let month: String
	var days: [ComicDay]
}

struct ComicDay {
	let day: String
	let title: String
}

protocol ComicPickerDelegate {
	func currentSelection(_ selection: String, type: PickerType)
}

protocol DatePickerDelegate {
	func stoppedScrolling(row: Int, type: DatePickerType)
}


fileprivate typealias Throttle = () -> Void
fileprivate var currentListWorkItem: DispatchWorkItem?
fileprivate func throttle(delay: DispatchTimeInterval, queue: DispatchQueue = .main, action: @escaping Throttle) -> Throttle {
	return {
		currentListWorkItem?.cancel()
		currentListWorkItem = DispatchWorkItem { action() }
		queue.asyncAfter(deadline: .now() + delay, execute: currentListWorkItem!)
		
	}
}
