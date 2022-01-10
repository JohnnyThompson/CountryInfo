//
//  CountryListViewModel.swift
//  CountryInfo
//
//  Created by Евгений Карпов on 10.01.2022.
//

import Foundation

protocol CountryListViewModelProtocol {
  var countries: Countries { get }
  func fetchCountries(completion: @escaping() -> Void)
  func numberOfRows() -> Int
  func cellViewModel(at indexPath: IndexPath) -> CountryTableViewCellViewModelProtocol
  func toggleFavoriteStatus(at indexPath: IndexPath)
  func returnFavoriteStatus(at indexPath: IndexPath) -> Bool
  func viewModelForSelectedRow(at indexPath: IndexPath) -> CountryDetailsViewModelProtocol
  func search(with string: String, completion: @escaping () -> Void)
  func cancelSearch(completion: @escaping () -> Void)
}

class CountryListViewModel: CountryListViewModelProtocol {
  // MARK: - Properties
  var countries = Countries()
  private var tmpCountries = Countries()
  
  // MARK: - Public functions
  func fetchCountries(completion: @escaping () -> Void) {
    NetworkManager.shared.fetchData { [unowned self] countries in
      self.countries = countries
      self.tmpCountries = countries
      self.tmpCountries.sort { $0.name.common < $1.name.common}
      self.countries.sort { $0.name.common < $1.name.common}
      completion()
    }
  }
  
  func numberOfRows() -> Int {
    countries.count
  }
  
  func cellViewModel(at indexPath: IndexPath) -> CountryTableViewCellViewModelProtocol {
    let country = countries[indexPath.row]
    return CountryTableViewCellViewModel(country: country)
  }
  
  func toggleFavoriteStatus(at indexPath: IndexPath) {
    let country = countries[indexPath.row]
    StorageManager.shared.toggleFavoriteStatus(for: country.name.common)
  }
  
  func returnFavoriteStatus(at indexPath: IndexPath) -> Bool {
    let country = countries[indexPath.row]
    return StorageManager.shared.getFavoriteStatus(for: country.name.common)
  }
  
  func viewModelForSelectedRow(at indexPath: IndexPath) -> CountryDetailsViewModelProtocol {
    let country = countries[indexPath.row]
    return CountryDetailsViewModel(country: country)
  }
  
  func search(with string: String, completion: @escaping () -> Void) {
    countries = []
    if string == "" {
      countries = tmpCountries
      completion()
    } else {
      tmpCountries.forEach { country in
        if country.name.common.lowercased().contains(string.lowercased()){
          countries.append(country)
        }
      }
      completion()
    }
  }
  
  func cancelSearch(completion: @escaping () -> Void) {
    countries = tmpCountries
    completion()
  }
}
