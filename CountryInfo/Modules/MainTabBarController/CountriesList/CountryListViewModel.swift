//
//  CountryListViewModel.swift
//  CountryInfo
//
//  Created by Евгений Карпов on 10.01.2022.
//

import Foundation

protocol CountryListViewModelProtocol {
  var countries: Countries { get }
  init(networkManager: NetworkManagerProtocol, storageManager: StorageManagerProtocol)
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
  private var networkManager: NetworkManagerProtocol
  private var storageManager: StorageManagerProtocol
  var countries = Countries()
  private var tmpCountries = Countries()
  
  // MARK: - Initialization
  required init(networkManager: NetworkManagerProtocol = NetworkManager.shared,
                storageManager: StorageManagerProtocol = StorageManager.shared) {
    self.networkManager = networkManager
    self.storageManager = storageManager
  }
  
  // MARK: - Public functions
  func fetchCountries(completion: @escaping () -> Void) {
    networkManager.fetchData { [unowned self] countries in
      self.countries = countries.sorted { $0.name.common < $1.name.common}
      self.tmpCountries = countries.sorted { $0.name.common < $1.name.common}
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
    storageManager.toggleFavoriteStatus(for: country.name.common)
  }
  
  func returnFavoriteStatus(at indexPath: IndexPath) -> Bool {
    let country = countries[indexPath.row]
    return storageManager.getFavoriteStatus(for: country.name.common)
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
