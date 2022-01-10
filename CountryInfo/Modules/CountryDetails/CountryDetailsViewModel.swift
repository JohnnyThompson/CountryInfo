//
//  CountryDetailsViewModel.swift
//  CountryInfo
//
//  Created by Евгений Карпов on 10.01.2022.
//

import Foundation

protocol CountryDetailsViewModelProtocol {
  var flagImage: Data { get }
  var officialName: String { get }
  var regionName: String { get }
  var capital: String { get }
  var population: String { get }
  var timeZone: String { get }
  init(country: Country)
}

class CountryDetailsViewModel: CountryDetailsViewModelProtocol {
  // MARK: - Properties
  var flagImage: Data {
    ImageManager.shared.fetchImage(from: country.flags.png) ?? Data()
  }
  
  var officialName: String {
    country.name.official
  }
  
  var regionName: String {
    "Region: \(country.region)"
  }
  
  var capital: String {
    var resultString = "Capital:"
    country.capital.forEach { capital in
      resultString.append(" \(capital)")
    }
    return resultString
  }
  
  var population: String {
    "Population: \(country.population)"
  }
  
  var timeZone: String {
    var resultString = "Time zones:"
    country.timezones.forEach { timeZone in
      resultString.append(" \(timeZone)")
    }
    return resultString
  }
  
  private var country: Country
  
  // MARK: - Initialization
  required init(country: Country) {
    self.country = country
  }
}
