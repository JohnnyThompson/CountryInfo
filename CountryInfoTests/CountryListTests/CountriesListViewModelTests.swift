//
//  CountriesListViewModelTests.swift
//  CountryInfoTests
//
//  Created by Евгений Карпов on 17.01.2022.
//

import XCTest
@testable import CountryInfo

fileprivate class MockNetworkManager: NetworkManagerProtocol {
  func fetchData(completion: @escaping (Countries) -> Void) {
    let countries: Countries = [Country(flags: Flags(png: "Foo"),
                                        name: Name(common: "Bar",
                                                   official: "Baz"),
                                        capital: ["Foo"],
                                        region: "Bar",
                                        population: 1000,
                                        timezones: ["Baz"]),
                                Country(flags: Flags(png: "Foo"),
                                        name: Name(common: "Foo",
                                                   official: "Bar"),
                                        capital: ["Foo"],
                                        region: "Bar",
                                        population: 1000,
                                        timezones: ["Baz"])]
    completion(countries)
  }
}

fileprivate class MockStorageManager: StorageManagerProtocol {
  private var storage: [String: Bool] = ["Foo" : true, "Bar" : false]
  
  func setFavoriteStatus(for countryName: String, with status: Bool) {
    storage[countryName] = status
  }
  
  func getFavoriteStatus(for countryName: String) -> Bool {
    return storage[countryName] ?? false
  }
  
  func toggleFavoriteStatus(for countryName: String) {
    storage[countryName]?.toggle()
  }
}

class CountriesListViewModelTests: XCTestCase {
  
  var sut: CountryListViewModel!
  private var networkManager: MockNetworkManager!
  private var storageManager: MockStorageManager!
  
  var countries: Countries = []
  var completion: Bool = false
  let indexPath = IndexPath(row: 0, section: 0)
  var country: Country!
  
  override func setUp() {
    super.setUp()
    self.networkManager = MockNetworkManager()
    self.storageManager = MockStorageManager()
    self.sut = CountryListViewModel(networkManager: networkManager,
                                    storageManager: storageManager)
    sut.fetchCountries {}
    networkManager.fetchData { countries in
      self.countries = countries.sorted { $0.name.common < $1.name.common}
    }
    country = countries[indexPath.row]
  }
  
  override func tearDown() {
    networkManager = nil
    storageManager = nil
    sut = nil
    super.tearDown()
  }
  
  func testFetchingDataFromNetworkManager() {
    sut.fetchCountries { [unowned self] in
      completion = true
    }
    XCTAssert(sut.countries == countries, "CountryListViewModel fetched incorrect data")
    XCTAssert(completion, "CountryListViewModel did not start executing completion when fetching data")
  }
  
  func testCountOfRows() {
    XCTAssert(sut.numberOfRows() == countries.count)
  }
  
  func testSearchWithEmptyString() {
    sut.search(with: "") { [unowned self] in
      completion = true
    }
    XCTAssert(sut.countries == countries, "CountryListViewModel failed searching with empty string")
    XCTAssert(completion, "CountryListViewModel did not start executing completion when searching")
  }
  
  func testSearchWithSomeString() {
    let countries = [Country(flags: Flags(png: "Foo"),
                             name: Name(common: "Foo",
                                        official: "Bar"),
                             capital: ["Foo"],
                             region: "Bar",
                             population: 1000,
                             timezones: ["Baz"])]
    sut.search(with: "f") { [unowned self] in
      completion = true
    }
    XCTAssert(sut.countries == countries, "CountryListViewModel failed searching with empty string")
    XCTAssert(completion, "CountryListViewModel did not start executing completion when searching")
  }
  
  func testCancelSearching() {
    sut.cancelSearch { [unowned self] in
      completion = true
    }
    XCTAssert(sut.countries == countries, "CountryListViewModel did not return original countries when exited the search")
    XCTAssert(completion, "CountryListViewModel did not start executing completion when exited the search")
  }
  
  func testReturnFavoriteStatusForCountry() {
    XCTAssert(!sut.returnFavoriteStatus(at: indexPath), "CountryListViewModel return wrong favorite status")
  }
  
  func testToggleFavoriteStatusForCounty() {
    let countryName = countries[indexPath.row].name.common
    
    sut.toggleFavoriteStatus(at: indexPath)
    
    XCTAssert(storageManager.getFavoriteStatus(for: countryName), "CountryListViewModel failed toggling favorite status")
  }
  
  func testReturnCorrectCellViewModel() {
    let cellViewModel: CountryTableViewCellViewModelProtocol = CountryTableViewCellViewModel(country: country)
    
    XCTAssert(sut.cellViewModel(at: indexPath).countryName == cellViewModel.countryName, "CountryListViewModel return wrong cellViewModel")
  }
  
  func testReturnCorrectDetailViewModel() {
    let detailViewModel: CountryDetailsViewModelProtocol = CountryDetailsViewModel(country: country)
    
    XCTAssert(sut.viewModelForSelectedRow(at: indexPath).officialName == detailViewModel.officialName, "CountryListViewModel return wrong detailViewModel")
  }
}
