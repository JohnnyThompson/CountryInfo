//
//  StorageManager.swift
//  CountryInfo
//
//  Created by Евгений Карпов on 09.01.2022.
//

import Foundation


class StorageManager {
  // MARK: - Properties
  static let shared = StorageManager()
  let defaults = UserDefaults.standard
  let countryKey = "countries"
  
  // MARK: - Initialization
  private init() {}
  
  // MARK: - Public function
  
  func setFavoriteStatus(for countryName: String, with status: Bool) {
    defaults.set(status, forKey: countryName)
  }
  
  func getFavoriteStatus(for countryName: String) -> Bool {
    defaults.bool(forKey: countryName)
  }
  
  func toggleFavoriteStatus(for countryName: String) {
    var favoriteStatus = getFavoriteStatus(for: countryName)
    favoriteStatus.toggle()
    setFavoriteStatus(for: countryName, with: favoriteStatus)
  }
}
