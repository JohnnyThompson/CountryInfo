//
//  MainTabBarController.swift
//  CountryInfo
//
//  Created by Евгений Карпов on 06.01.2022.
//

import UIKit

class MainTabBarController: UITabBarController {
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let countriesListViewController = CountriesListViewController()
    let favoriteCountryViewController = FavoriteCountriesViewController()
    
    tabBar.tintColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
    
    let boldConfiguration = UIImage.SymbolConfiguration(weight: .medium)
    let countriesListImage = UIImage(
      systemName: "list.dash",
      withConfiguration: boldConfiguration) ?? UIImage()
    let favoriteCountryImage = UIImage(
      systemName: "star",
      withConfiguration: boldConfiguration) ?? UIImage()
    
    viewControllers = [
      generateNavigationController(rootViewController: countriesListViewController,
                                   title: "Countries",
                                   image: countriesListImage),
      generateNavigationController(rootViewController: favoriteCountryViewController,
                                   title: "Favorite",
                                   image: favoriteCountryImage)
    ]
  }
  
  // MARK: - Module functions
  
  /// Возвращает ViewController обернутый в NavigationController
  ///
  /// - Параметры:
  ///   - rootViewController: Корневой ViewController
  ///   - title: Заголовок, который будет отображаться в TabBarController
  ///   - image: Изображение, которое будет отображаться в TabBarController
  private func generateNavigationController(rootViewController: UIViewController,
                                            title: String,
                                            image: UIImage) -> UIViewController {
    let navigationVC = UINavigationController(rootViewController: rootViewController)
    navigationVC.tabBarItem.title = title
    navigationVC.tabBarItem.image = image
    return navigationVC
  }
}
