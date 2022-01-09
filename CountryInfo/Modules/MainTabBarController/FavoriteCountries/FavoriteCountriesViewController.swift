//
//  FavoriteCountriesViewController.swift
//  CountryInfo
//
//  Created by Евгений Карпов on 06.01.2022.
//

import UIKit

protocol FavoriteCountriesViewControllerProtocol: AnyObject {
  
}

class FavoriteCountriesViewController: UIViewController, FavoriteCountriesViewControllerProtocol {
  // MARK: - Properties
  let tableView = UITableView()
  private var countries = Countries()
  private var favoriteCountries = Countries()
  private var didSetupConstraints = false
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Favorite Countries"
    fetchData()
    setupViews()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    checkFavoriteCountries()
  }
  
  override func updateViewConstraints() {
    super.updateViewConstraints()
    if !didSetupConstraints {
      view.backgroundColor = #colorLiteral(red: 0.9750193954, green: 0.97865659, blue: 0.9938426614, alpha: 1)
      setupConstraints()
      didSetupConstraints = true
    }
  }
  
  // MARK: - Module functions
  private func setupViews() {
    tableView.dataSource = self
    tableView.delegate = self
    tableView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(tableView)
  }
  
  private func fetchData() {
    NetworkManager.shared.fetchData { [unowned self] countries in
      self.countries = countries
      self.countries.sort { $0.name.common < $1.name.common}
      checkFavoriteCountries()
    }
  }
  
  private func checkFavoriteCountries() {
    favoriteCountries = []
    countries.forEach { country in
      let isFavorite = StorageManager.shared.getFavoriteStatus(for: country.name.common)
      if isFavorite{
        favoriteCountries.append(country)
      }
    }
    tableView.reloadData()
  }
}

// MARK: - UITableViewDataSource
extension FavoriteCountriesViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return favoriteCountries.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell") as? CountryCell  else {
      let newCell = CountryCell(style: .default, reuseIdentifier: "CountryCell", country: favoriteCountries[indexPath.row])
      return newCell
    }
    cell.configure(with: favoriteCountries[indexPath.row])
    return cell
  }
}

// MARK: - UITableViewDelegate
extension FavoriteCountriesViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let country = favoriteCountries[indexPath.row]
    var detailsVC: CountryDetailsViewControllerProtocol = CountryDetailsViewController()
    detailsVC.country = country
    navigationController?.pushViewController(detailsVC as! UIViewController, animated: true)
  }
  
  func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let action = UIContextualAction(style: .normal, title: "isFavorite") { [unowned self] _, _, _ in
      var isFavorite = StorageManager.shared.getFavoriteStatus(for: favoriteCountries[indexPath.row].name.common)
      isFavorite.toggle()
      StorageManager.shared.setFavoriteStatus(for: favoriteCountries[indexPath.row].name.common, with: isFavorite)
      favoriteCountries.remove(at: indexPath.row)
      tableView.reloadSections(IndexSet(arrayLiteral: indexPath.section),with: .automatic)
    }
    return UISwipeActionsConfiguration(actions: [action])
  }
}

// MARK: - Setup Constraints
extension FavoriteCountriesViewController {
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
    ])
  }
}

