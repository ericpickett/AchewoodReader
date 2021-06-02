//
//  ComicCollectionViewController.swift
//  AchewoodReader
//
//  Created by eric on 2020/12/18.
//

import UIKit

private let reuseIdentifier = "ComicCell"
private let currentPageKey = "current_page"

class ComicCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(ComicCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
		self.collectionView.backgroundColor = .systemGray
		self.collectionView.isPagingEnabled = true
		let currentPageIndex = UserDefaults.standard.integer(forKey: currentPageKey)
		self.collectionView.scrollToItem(at: IndexPath(row: currentPageIndex, section: 0), at: .centeredHorizontally, animated: false)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return comics.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
		if let comicCell = cell as? ComicCollectionViewCell {
			let comic = comics[indexPath.row]
			let image = ImageStore.shared.image(name: comic.date)
			comicCell.setImage(image)
		}
    
        return cell
    }

    // MARK: UICollectionViewDelegate
	override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		let center = CGPoint(x: scrollView.contentOffset.x + (scrollView.frame.width / 2), y: (scrollView.frame.height / 2))
		if let currentIndex = collectionView.indexPathForItem(at: center)?.row {
			UserDefaults.standard.set(currentIndex, forKey: currentPageKey)
		}
	}
}

extension ComicCollectionViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return collectionView.visibleSize
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
	
}

extension ComicCollectionViewController: NavigationMenuDelegate {
	func loadComicBy(date: String) {
		if let row = comics.firstIndex(where: { $0.date == date }) {
			let index = IndexPath(row: row, section: 0)
			self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
			UserDefaults.standard.set(row, forKey: currentPageKey)
		}
	}
	
	func loadComicBy(title: String) {
		if let row = comics.firstIndex(where: { $0.title == title }) {
			let index = IndexPath(row: row, section: 0)
			self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
			UserDefaults.standard.set(row, forKey: currentPageKey)
		}
	}
	
	func loadComicBy(caption: String) {
		if let row = comics.firstIndex(where: { $0.caption == caption }) {
			let index = IndexPath(row: row, section: 0)
			self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
			UserDefaults.standard.set(row, forKey: currentPageKey)
		}
	}
}
