//
//  PhotosCell.swift
//  Pixels
//
//  Created by Vladimir Fibe on 31.01.2022.
//

import UIKit
import SDWebImage

class PhotosCell: UICollectionViewCell {
  static let reuseId = "PhotosCell"
  
  private let checkmark: UIImageView = {
    let image = UIImage(systemName: "checkmark.circle.fill")
    let imageView = UIImageView(image: image)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.alpha = 0
    return imageView
  }()
  
  let photoImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.backgroundColor = .systemGray4
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  var unsplashPhoto: UnSplashPhoto! {
    didSet {
      guard let imageUrl = unsplashPhoto.urls["regular"], let url = URL(string: imageUrl) else { return }
      photoImageView.sd_setImage(with: url, completed: nil)
    }
  }
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupPhotoImageView()
    setupCheckmarkView()
    updateSelectedState()
  }
  override func prepareForReuse() {
    super.prepareForReuse()
    photoImageView.image = nil
  }
  
  override var isSelected: Bool {
    didSet {
      updateSelectedState()
    }
  }
  
  private func updateSelectedState() {
    photoImageView.alpha = isSelected ? 0.7 : 1
    checkmark.alpha = isSelected ? 1 : 0
  }
  private func setupPhotoImageView() {
    addSubview(photoImageView)
    photoImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    photoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    photoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
  }
  
  private func setupCheckmarkView() {
    addSubview(checkmark)
    checkmark.trailingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: -8).isActive = true
    checkmark.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: -8).isActive = true
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
