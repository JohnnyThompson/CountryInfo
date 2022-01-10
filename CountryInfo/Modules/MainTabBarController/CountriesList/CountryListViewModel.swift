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
  func viewModelForSelectedRow(at indexPath: IndexPath) -> CountryDetailsViewModelProtocol
}

class CountryListViewModel: CountryListViewModelProtocol {
  // MARK: - Properties
  var countries: Countries = []
  
  // MARK: - Public functions
  func fetchCountries(completion: @escaping () -> Void) {
    NetworkManager.shared.fetchData { [unowned self] countries in
      self.countries = countries
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
  
  func viewModelForSelectedRow(at indexPath: IndexPath) -> CountryDetailsViewModelProtocol {
    let country = countries[indexPath.row]
    return CountryDetailsViewModel(country: country)
  }
}
