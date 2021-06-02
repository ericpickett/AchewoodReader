//
//  Data.swift
//  AchewoodReader
//
//  Created by eric on 2020/11/02.
//

import Foundation
import UIKit

let comics: [Comic] = {
	var comics: [Comic] = load("comics", extension: "plist")
	comics.sort { return $0.date < $1.date ? true : false }
	
	return comics
}()

func load<T: Decodable>(_ filename: String, extension ext: String? = nil) -> T {
	let data: Data
	
	guard let file = Bundle.main.url(forResource: filename, withExtension: ext)
		else {
			fatalError("Couldn't find \(filename) in main bundle.")
	}
	
	do {
		data = try Data(contentsOf: file)
	} catch {
		fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
	}
	
	do {
		let decoder = PropertyListDecoder()
		return try decoder.decode(T.self, from: data)
	} catch {
		fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
	}
}

final class ImageStore {
	typealias _ImageDictionary = [String: CGImage]
	fileprivate var images: _ImageDictionary = [:]

	fileprivate static var scale = 1
	
	static var shared = ImageStore()
	
	func image(name: String) -> UIImage {
		let index = _guaranteeImage(name: name)
		
		return UIImage(cgImage: images.values[index])
	}

	static func loadImage(name: String) -> CGImage {
		guard
			let url = Bundle.main.url(forResource: name, withExtension: "png"),
			let imageSource = CGImageSourceCreateWithURL(url as NSURL, nil),
			let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
		else {
			fatalError("Couldn't load image \(name).png from main bundle.")
		}
		return image
	}
	
	fileprivate func _guaranteeImage(name: String) -> _ImageDictionary.Index {
		if let index = images.index(forKey: name) { return index }
		
		images[name] = ImageStore.loadImage(name: name)
		return images.index(forKey: name)!
	}
}
