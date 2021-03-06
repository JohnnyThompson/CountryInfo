//
//  FavoriteCountriesViewModel.swift
//  CountryInfo
//
//  Created by Евгений Карпов on 10.01.2022.
//

import Foundation

protocol FavoriteCountriesViewModelProtocol {
  var networkManager: NetworkManagerProtocol { get }
  var favoriteCountries: Countries { get }
  func fetchCountries(completion: @escaping() -> Void)
  func checkFavoriteCountries()
  func numberOfRows() -> Int
  func cellViewModel(at indexPath: IndexPath) -> CountryTableViewCellViewModelProtocol
  func deleteFromFavorite(at indexPath: IndexPath)
  func viewModelForSelectedRow(at indexPath: IndexPath) -> CountryDetailsViewModelProtocol
  func search(with string: String, completion: @escaping () -> Void)
  func cancelSearch(completion: @escaping () -> Void)
}

class FavoriteCountriesViewModel: FavoriteCountriesViewModelProtocol {
  // MARK: - Properties
  var networkManager: NetworkManagerProtocol = NetworkManager.shared
  private var countries = Countries()
  var favoriteCountries = Countries()
  private var tmpFavoriteCountries = Countries()
  
  // MARK: - Public functions
  func fetchCountries(completion: @escaping () -> Void) {
    networkManager.fetchData { [unowned self] countries in
      self.countries = countries
      checkFavoriteCountries()
      completion()
    }
  }
  
  func checkFavoriteCountries() {
    favoriteCountries = []
    countries.forEach { country in
      if StorageManager.shared.getFavoriteStatus(for: country.name.common) {
        favoriteCountries.append(country)
      }
    }
    favoriteCountries.sort { $0.name.common < $1.name.common}
    tmpFavoriteCountries = favoriteCountries
  }
  
  func numberOfRows() -> Int {
    favoriteCountries.count
  }
  
  func cellViewModel(at indexPath: IndexPath) -> CountryTableViewCellViewModelProtocol {
    let country = favoriteCountries[indexPath.row]
    return CountryTableViewCellViewModel(country: country)
  }
  
  func deleteFromFavorite(at indexPath: IndexPath) {
    let country = favoriteCountries[indexPath.row]
    favoriteCountries.remove(at: indexPath.row)
    StorageManager.shared.setFavoriteStatus(for: country.name.common, with: false)
  }
  
  func viewModelForSelectedRow(at indexPath: IndexPath) -> CountryDetailsViewModelProtocol {
    let country = favoriteCountries[indexPath.row]
    return CountryDetailsViewModel(country: country)
  }
  
  func search(with string: String, completion: @escaping () -> Void) {
    favoriteCountries = []
    if string == "" {
      favoriteCountries = tmpFavoriteCountries
      completion()
    } else {
      tmpFavoriteCountries.forEach { country in
        if country.name.common.lowercased().contains(string.lowercased()){
          favoriteCountries.append(country)
        }
      }
      completion()
    }
  }
  
  func cancelSearch(completion: @escaping () -> Void) {
    favoriteCountries = tmpFavoriteCountries
    completion()
  }
}
