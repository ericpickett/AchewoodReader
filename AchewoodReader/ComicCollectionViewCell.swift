//
//  ComicCollectionViewCell.swift
//  AchewoodReader
//
//  Created by eric on 2021/05/14.
//

import UIKit

class ComicCollectionViewCell: UICollectionViewCell {
	private let scrollView: UIScrollView = {
		let scroll = UIScrollView()
		scroll.maximumZoomScale = 3
		
		return scroll
	}()
	
	private lazy var scrollViewConstraints: [NSLayoutConstraint] = {
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		
		return [
			scrollView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 3),
			scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
			scrollView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -3),
			scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
		]
	}()
	
	private let imageView: UIImageView = {
		let view = UIImageView()
		view.contentMode = .scaleAspectFit
		
		return view
	}()
	
	private lazy var imageViewConstraints: [NSLayoutConstraint] = {
		imageView.translatesAutoresizingMaskIntoConstraints = false
		
		return [
			imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
			imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
			imageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
			imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
		]
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.backgroundColor = .white
		
		scrollView.delegate = self
		scrollView.addSubview(imageView)
		self.addSubview(scrollView)
		
		
		NSLayoutConstraint.activate(scrollViewConstraints)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setImage(_ image: UIImage) -> Void {
		self.imageView.image = image
		self.setNeedsUpdateConstraints()
	}
	
	override func updateConstraints() {
		super.updateConstraints()
		
		NSLayoutConstraint.activate(imageViewConstraints)
	}
}

extension ComicCollectionViewCell: UIScrollViewDelegate {
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return self.imageView
	}
}
