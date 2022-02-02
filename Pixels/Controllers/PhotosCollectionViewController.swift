//
//  PhotosCollectionViewController.swift
//  Pixels
//
//  Created by Vladimir Fibe on 30.01.2022.
// 

import UIKit

class PhotosCollectionViewController: UICollectionViewController {
  let cellId = "CellId"
  var netorkDataFetcherDataFetcher = NetworkDataFetcher()
  private var photos = [UnSplashPhoto]()
  private var timer: Timer?
  private let itemsPerRow: CGFloat = 2.0
  private let sectionInserts = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
  private var imageSet = Set<UIImage>()
  var selectedImage: [UIImage] {
    Array(imageSet)
  }
  private lazy var addBarButtonItem: UIBarButtonItem = {
    UIBarButtonItem(barButtonSystemItem: .add,
                           target: self,
                           action: #selector(addBarButtonTapped))
  }()

  private var numberOfSelectedPhotos: Int {
    collectionView.indexPathsForSelectedItems?.count ?? 1
  }
  private lazy var actionBarButtonItem: UIBarButtonItem = {
    UIBarButtonItem(barButtonSystemItem: .action,
                           target: self,
                           action: #selector(actionBarButtonTapped))
  }()
  override func viewDidLoad() {
    super.viewDidLoad()
    updateNavButtonsState()
    setupNavigationBar()
    setupCollectionView()
    setupSearchBar()
  }
  func updateNavButtonsState() {
    addBarButtonItem.isEnabled = numberOfSelectedPhotos > 0
    actionBarButtonItem.isEnabled = numberOfSelectedPhotos > 0
    print("DEBUG: \(numberOfSelectedPhotos)")

  }
  func refresh() {
    imageSet.removeAll()
    collectionView.selectItem(at: nil, animated: true, scrollPosition: [])
    updateNavButtonsState()
    
  }
  // MARK: - NavigationItems action
  @objc func addBarButtonTapped() {
    let selectedPhotos = collectionView.indexPathsForSelectedItems?.reduce([], { (photosss, indexPath) -> [UnSplashPhoto] in
      var mutablePhotos = photosss
      let photo = photos[indexPath.item]
      mutablePhotos.append(photo)
      return mutablePhotos
    })
    
    let alertController = UIAlertController(title: "", message: "\(selectedPhotos!.count) фото будут добавлены в альбом", preferredStyle: .alert)
    let add = UIAlertAction(title: "Добавить", style: .default) { action in
      let tabbar = self.tabBarController as! MainTabBarController
      let nav = tabbar.viewControllers?[1] as! UINavigationController
      let favorite = nav.topViewController as! FavoritePhotosViewController
      favorite.photos.append(contentsOf: selectedPhotos ?? [])
      favorite.collectionView.reloadData()
      self.refresh()
    }
    let cancel = UIAlertAction(title: "Отменить", style: .cancel) { action in
      
    }
    alertController.addAction(add)
    alertController.addAction(cancel)
    present(alertController, animated: true)
  }
  @objc func actionBarButtonTapped(sender: UIBarButtonItem) {
    let shareController = UIActivityViewController(activityItems: selectedImage, applicationActivities: nil)
    shareController.completionWithItemsHandler = { _, bool, _, _ in
      if bool {
        self.refresh()
      }
      
    }
    shareController.popoverPresentationController?.barButtonItem = sender
    shareController.popoverPresentationController?.permittedArrowDirections = .any
    present(shareController, animated: true, completion: nil)
  }
  
  // MARK: - Setup UI Elements
  private func setupCollectionView() {
    collectionView.register(UICollectionViewCell.self,
                            forCellWithReuseIdentifier: cellId)
    collectionView.register(PhotosCell.self, forCellWithReuseIdentifier: PhotosCell.reuseId)
    collectionView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    collectionView.contentInsetAdjustmentBehavior = .automatic
    collectionView.allowsMultipleSelection = true
  }
  
  private func setupNavigationBar() {
    let titleLabel = UILabel()
    titleLabel.text = "PHOTOS"
    titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
    titleLabel.textColor = #colorLiteral(red: 0.5742436647, green: 0.5705327392, blue: 0.5704542994, alpha: 1) // 807F7F
    
    navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
    navigationItem.rightBarButtonItems = [actionBarButtonItem, addBarButtonItem]
  }
  
  private func setupSearchBar() {
    let searchController = UISearchController(searchResultsController: nil)
    searchController.searchBar.delegate = self
    searchController.hidesNavigationBarDuringPresentation = false
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
  }
  
  // MARK: - UICollectionViewDataSource, UICollectionViewDelegate
  override func collectionView(_ collectionView: UICollectionView,
                               numberOfItemsInSection section: Int) -> Int {
    return photos.count
  }
  
  override func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCell.reuseId, for: indexPath) as! PhotosCell
    let unsplashPhoto = photos[indexPath.item]
    cell.unsplashPhoto = unsplashPhoto
    return cell
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let cell = collectionView.cellForItem(at: indexPath) as! PhotosCell
    guard let image = cell.photoImageView.image else { return }
    imageSet.insert(image)
    updateNavButtonsState()
     
  }
  
  override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    let cell = collectionView.cellForItem(at: indexPath) as! PhotosCell
    guard let image = cell.photoImageView.image else { return }
    imageSet.remove(image)
    updateNavButtonsState()
  }
}
// MARK: - UISearchBarDelegate
extension PhotosCollectionViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    timer?.invalidate()
    timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
      self.netorkDataFetcherDataFetcher.fetchImages(search: searchText) {[weak self] searchResults in
        guard let fetchedPhotos = searchResults else { return }
        self?.photos = fetchedPhotos.results
        self?.collectionView.reloadData()
        self?.refresh()
      }
    })
  }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension PhotosCollectionViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let photo = photos[indexPath.item]
    let paddingSpace = sectionInserts.left * (itemsPerRow + 1)
    let availableWidth = view.frame.width - paddingSpace
    let widthPerItem = availableWidth / itemsPerRow
    let height = CGFloat(photo.height) * widthPerItem / CGFloat(photo.width)
    return CGSize(width: widthPerItem, height: height)
}
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    sectionInserts
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    sectionInserts.left
  }
}
