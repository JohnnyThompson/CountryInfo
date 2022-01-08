//
//  ImageManager.swift
//  CountryInfo
//
//  Created by Евгений Карпов on 07.01.2022.
//

import Foundation

class ImageManager {
    static let shared = ImageManager()
    
    private init() {}
    
    func fetchImage(from url: URL?) -> Data? {
        guard let url = url else { return nil }
        guard let imageData = try? Data(contentsOf: url) else { return nil}
        return imageData
    }
}
