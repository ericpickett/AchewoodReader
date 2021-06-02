//
//  HomePageViewController.swift
//  AchewoodReader
//
//  Created by eric on 2020/12/14.
//

import UIKit

class HomePageViewController: UIViewController {
	private let comicsCollection: ComicCollectionViewController = {
		let layout = ComicCollectionFlowLayout()
		let collection = ComicCollectionViewController(collectionViewLayout: layout)
		
		return collection
	}()
	
	private lazy var comicsCollectionConstraints: [NSLayoutConstraint] = {
		comicsCollection.view.translatesAutoresizingMaskIntoConstraints = false
		return [
			comicsCollection.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			comicsCollection.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			comicsCollection.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			comicsCollection.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
		]
	}()
	
	private let navMenu = NavigationMenuView()
	
	private lazy var navMenuConstraints: [NSLayoutConstraint] = {
		self.navMenu.translatesAutoresizingMaskIntoConstraints = false
		
		return [
			self.navMenu.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
			self.navMenu.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 3),
			self.navMenu.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
			self.navMenu.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
		]
	}()
	
	private lazy var navMenuButton: UIButton = {
		let button = UIButton()
		button.titleLabel?.numberOfLines = 0
		button.setTitle("...", for: .normal)
		button.setTitleColor(.darkText, for: .normal)
		button.addTarget(self, action: #selector(navButtonPressed(sender:)), for: .touchUpInside)
		
		return button
	}()
	
	private lazy var navMenuButtonConstraints: [NSLayoutConstraint] = {
		navMenuButton.translatesAutoresizingMaskIntoConstraints = false
		
		return [
			navMenuButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
			navMenuButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
		]
	}()
	
	@objc func navButtonPressed(sender: UIButton) {
		self.navMenu.isHidden = false
		self.navMenu.updateCurrentSelection()
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		navMenu.delegate = comicsCollection
		
		self.view.addSubview(comicsCollection.view)
		self.view.addSubview(navMenuButton)
		self.view.addSubview(navMenu)
		
		NSLayoutConstraint.activate(
			comicsCollectionConstraints
			+ navMenuConstraints
			+ navMenuButtonConstraints
		)
    }
}
