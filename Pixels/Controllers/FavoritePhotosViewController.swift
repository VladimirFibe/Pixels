//
//  FavoritePhotosViewController.swift
//  Pixels
//
//  Created by Vladimir Fibe on 31.01.2022.
//

import Foundation
import UIKit

class FavoritePhotosViewController: UICollectionViewController {
  
  var photos = [UnSplashPhoto]()
  
  private lazy var trashBarButtonItem: UIBarButtonItem = {
    UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: nil)
  }()
  
  private let enterSearchTermLabel: UILabel = {
    let label = UILabel()
    label.text = "You haven't add a photos yet"
    label.textAlignment = .center
    label.font = UIFont.boldSystemFont(ofSize: 20)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.backgroundColor = .white
    collectionView.register(FavoriteCell.self, forCellWithReuseIdentifier: FavoriteCell.reuseId)
    collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    layout.minimumInteritemSpacing = 1
    layout.minimumLineSpacing = 1
    
    setupNavigationBar()
    setupEnterLabel()
  }
  
  private func setupEnterLabel() {
    collectionView.addSubview(enterSearchTermLabel)
    enterSearchTermLabel.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor).isActive = true
    enterSearchTermLabel.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor).isActive = true
  }
  
  private func setupNavigationBar() {
    let titleLabel = UILabel()
    titleLabel.text = "FAVORITES"
    titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
    titleLabel.textColor = #colorLiteral(red: 0.5742436647, green: 0.5705327392, blue: 0.5704542994, alpha: 1) // 807F7F
    navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
    navigationItem.rightBarButtonItem = trashBarButtonItem
    trashBarButtonItem.isEnabled = false
  }
  
  override func collectionView(_ collectionView: UICollectionView,
                               numberOfItemsInSection section: Int) -> Int {
    enterSearchTermLabel.isHidden = !photos.isEmpty
    return photos.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCell.reuseId, for: indexPath) as! FavoriteCell
    let unsplashPhoto = photos[indexPath.item]
    cell.unsplashPhoto = unsplashPhoto
    return cell
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let controller = DetailPhotoViewController()
    navigationController?.pushViewController(controller, animated: true)
  }
}

extension FavoritePhotosViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = collectionView.frame.width / 3 - 1
    return CGSize(width: width, height: width)
  }
}
