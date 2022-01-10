//
//  FavoriteCountriesViewModel.swift
//  CountryInfo
//
//  Created by Евгений Карпов on 10.01.2022.
//

import Foundation

protocol FavoriteCountriesViewModelProtocol {
  var favoriteCountries: Countries { get }
  func fetchCountries(completion: @escaping() -> Void)
  func checkFavoriteCountries()
  func numberOfRows() -> Int
  func cellViewModel(at indexPath: IndexPath) -> CountryTableViewCellViewModelProtocol
  func deleteFromFavorite(at indexPath: IndexPath)
  func viewModelForSelectedRow(at indexPath: IndexPath) -> CountryDetailsViewModelProtocol
}

class FavoriteCountriesViewModel: FavoriteCountriesViewModelProtocol {
  // MARK: - Properties
  private var countries = Countries()
  var favoriteCountries = Countries()
  
  // MARK: - Public functions
  func fetchCountries(completion: @escaping () -> Void) {
    NetworkManager.shared.fetchData { [unowned self] countries in
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
}
