//
//  MainTabBarController.swift
//  Pixels
//
//  Created by Vladimir Fibe on 30.01.2022.
//

import UIKit

class MainTabBarController: UITabBarController {
  override func viewDidLoad() {
    super.viewDidLoad()
    let photos = PhotosCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
    let favourites = ViewController()
    viewControllers = [
      generateNavigationController(rootViewController: photos,
                                   title: "Photos",
                                   image: UIImage(systemName: "photo")!),
      generateNavigationController(rootViewController: favourites,
                                   title: "Favourites",
                                   image: UIImage(systemName: "heart")!)
    ]
  }
  
  private func generateNavigationController(rootViewController: UIViewController,
                                            title: String,
                                            image: UIImage) -> UIViewController {
    let navigation = UINavigationController(rootViewController: rootViewController)
    navigation.tabBarItem.title = title
    navigation.tabBarItem.image = image
    return navigation
  }
}
