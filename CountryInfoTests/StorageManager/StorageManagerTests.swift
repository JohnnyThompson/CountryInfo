//
//  StorageManagerTests.swift
//  CountryInfoTests
//
//  Created by Евгений Карпов on 17.01.2022.
//

import XCTest
@testable import CountryInfo

class StorageManagerTests: XCTestCase {
  
  var sut: StorageManagerProtocol!
  var countryName = "Foo"
  private let defaults = UserDefaults.standard
  
  override func setUp() {
    super.setUp()
    sut = StorageManager.shared
    defaults.set(false, forKey: countryName)
  }
  
  override func tearDown() {
    defaults.removeObject(forKey: countryName)
    sut = nil
    super.tearDown()
  }
  
  func testSetTrueFavoriteStatus() {
    sut.setFavoriteStatus(for: countryName, with: true)
    XCTAssert(defaults.bool(forKey: countryName), "Set true favorite status failed")
  }
  
  func testGetTrueFavoriteStatus() {
    defaults.set(true, forKey: countryName)
    XCTAssert(sut.getFavoriteStatus(for: countryName), "Get true favorite status failed")
  }
  
  func testTogglingFavoriteStatusIsCorrect() {
    sut.toggleFavoriteStatus(for: countryName)
    XCTAssert(defaults.bool(forKey: countryName), "Toggling favorite status for country failed")
  }
}
