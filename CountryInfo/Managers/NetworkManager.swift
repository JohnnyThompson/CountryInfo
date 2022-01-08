//
//  NetworkManager.swift
//  CountryInfo
//
//  Created by Евгений Карпов on 06.01.2022.
//

import Foundation

class NetworkManager {
  static let shared = NetworkManager()
  private var api = "https://restcountries.com/v3.1/all?fields=name,capital,region,subregion,population,timezones,flags"
  
  private init() { }
  
  func fetchData(completion: @escaping (_ countries: Countries) -> Void) {
      guard let url = URL(string: api) else {
        return
      }
      URLSession.shared.dataTask(with: url) { data, _, error in
          guard let data = data else {
              print(error?.localizedDescription ?? "No description")
              return
          }
          do {
              let decoder = JSONDecoder()
              let countries = try decoder.decode(Countries.self, from: data)
              DispatchQueue.main.async {
                  completion(countries)
              }
          } catch let error {
              print("Error serialization json", error)
          }
      }.resume()
  }
}
