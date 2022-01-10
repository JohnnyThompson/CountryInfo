//
//  CountryTableViewCellViewModel.swift
//  CountryInfo
//
//  Created by Евгений Карпов on 10.01.2022.
//

import Foundation

protocol CountryTableViewCellViewModelProtocol {
  var countryName: String { get }
  var favoriteButtonStatus: Bool { get }
  init(country: Country)
}

class CountryTableViewCellViewModel: CountryTableViewCellViewModelProtocol {
  // MARK: - Properties
  var countryName: String {
    country.name.common
  }
  var favoriteButtonStatus: Bool {
    StorageManager.shared.getFavoriteStatus(for: countryName)
  }
  private let country: Country
  
  // MARK: - Initialization
  required init(country: Country) {
    self.country = country
  }
}
