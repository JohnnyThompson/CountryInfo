//
//  ImageManager.swift
//  CountryInfo
//
//  Created by Евгений Карпов on 07.01.2022.
//

import Foundation

protocol ImageManagerProtocol {
  func fetchImage(from stringURL: String) -> Data?
}

class ImageManager: ImageManagerProtocol {
  // MARK: - Properties
  static let shared = ImageManager()
  
  // MARK: - Public function
  func fetchImage(from stringURL: String) -> Data? {
    guard let url = URL(string: stringURL) else {
      return nil
    }
    guard let imageData = try? Data(contentsOf: url) else {
      return nil}
    return imageData
  }
}
