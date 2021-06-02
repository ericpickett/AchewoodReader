//
//  ComicCollectionFlowLayout.swift
//  AchewoodReader
//
//  Created by eric on 2021/05/14.
//

import UIKit

class ComicCollectionFlowLayout: UICollectionViewFlowLayout {
	override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
		return true
	}
	
	override init() {
		super.init()
		
		self.scrollDirection = .horizontal
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
