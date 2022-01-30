//
//  PhotosCollectionViewController.swift
//  Pixels
//
//  Created by Vladimir Fibe on 30.01.2022.
//

import UIKit

class PhotosCollectionViewController: UICollectionViewController {
  let cellId = "CellId"
  
  private lazy var addBarButtonItem: UIBarButtonItem = {
    return UIBarButtonItem(barButtonSystemItem: .add,
                           target: self,
                           action: #selector(addBarButtonTapped))
  }()

  private lazy var actionBarButtonItem: UIBarButtonItem = {
    return UIBarButtonItem(barButtonSystemItem: .action,
                           target: self,
                           action: #selector(actionBarButtonTapped))
  }()
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()
    setupCollectionView()
  }
  // MARK: - NavigationItems action
  @objc func addBarButtonTapped() {
    print("DEBUG: \(#function)")
  }
  @objc func actionBarButtonTapped() {
    print("DEBUG: \(#function)")
  }
  
  // MARK: - Setup UI Elements
  private func setupCollectionView() {
    collectionView.register(UICollectionViewCell.self,
                            forCellWithReuseIdentifier: cellId)
  }
  
  private func setupNavigationBar() {
    let titleLabel = UILabel()
    titleLabel.text = "PHOTOS"
    titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
    titleLabel.textColor = #colorLiteral(red: 0.5742436647, green: 0.5705327392, blue: 0.5704542994, alpha: 1) // 807F7F
    
    navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
    navigationItem.rightBarButtonItems = [actionBarButtonItem, addBarButtonItem]
  }
  
  // MARK: - UICollectionViewDataSource, UICollectionViewDelegate
  override func collectionView(_ collectionView: UICollectionView,
                               numberOfItemsInSection section: Int) -> Int {
    return 5
  }
  
  override func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
    cell.backgroundColor = .red
    return cell
  }
}
