//
//  Countries.swift
//  CountryInfo
//
//  Created by Евгений Карпов on 06.01.2022.
//

import Foundation

typealias Countries = [Country]

struct Country: Codable, Equatable {
  let flags: Flags
  let name: Name
  let capital: [String]
  let region: String
  let population: Int
  let timezones: [String]
  
  static func == (lhs: Country, rhs: Country) -> Bool {
    guard lhs.flags == rhs.flags,
          lhs.name == rhs.name,
          lhs.capital == rhs.capital,
          lhs.region == rhs.region,
          lhs.population == rhs.population,
          lhs.timezones == rhs.timezones else {
            return false
          }
    return true
  }
}

struct Flags: Codable, Equatable {
  let png: String
}

struct Name: Codable, Equatable {
  let common: String
  let official: String
}
