//
//  Countries.swift
//  CountryInfo
//
//  Created by Евгений Карпов on 06.01.2022.
//

import Foundation

typealias Countries = [Country]

struct Country: Codable {
    let flags: Flags
    let name: Name
    let capital: [String]
    let region: String
    let subregion: String
    let population: Int
    let timezones: [String]
}

struct Flags: Codable {
    let png: URL
}

struct Name: Codable {
    let common: String
    let official: String
}
