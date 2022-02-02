//
//  FavoriteCell.swift
//  Pixels
//
//  Created by Vladimir Fibe on 01.02.2022.
//

import UIKit
import SDWebImage

class FavoriteCell: UICollectionViewCell {
  static let reuseId = "FavoriteCell"
  
  var favoriteImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.clipsToBounds = true
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  var unsplashPhoto: UnSplashPhoto! {
    didSet {
      guard let imageUrl = unsplashPhoto.urls["regular"], let url = URL(string: imageUrl) else { return }
      favoriteImageView.sd_setImage(with: url, completed: nil)
    }
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    favoriteImageView.image = nil
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupImageView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupImageView() {
    addSubview(favoriteImageView)
    favoriteImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    favoriteImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    favoriteImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    favoriteImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
  }
  
  func set(photo: UnSplashPhoto) {
    guard let photoURL = photo.urls["full"], let url = URL(string: photoURL) else { return }
    favoriteImageView.sd_setImage(with: url, completed: nil)
  }
}
