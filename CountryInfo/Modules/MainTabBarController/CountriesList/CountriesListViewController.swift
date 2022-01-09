//
//  CountriesListViewController.swift
//  CountryInfo
//
//  Created by Евгений Карпов on 06.01.2022.
//

import UIKit

protocol CountriesListViewControllerProtocol: AnyObject {
    
}

class CountriesListViewController: UIViewController, CountriesListViewControllerProtocol {
  
  // MARK: - Properties
  let tableView = UITableView()
  private var countries = Countries()
  private var didSetupConstraints = false
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Country Info"
    fetchData()
    setupViews()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    tableView.reloadData()
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
      tableView.reloadData()
    }
  }
}

// MARK: - UITableViewDataSource
extension CountriesListViewController: UITableViewDataSource {  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return countries.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell") as? CountryCell  else {
      let newCell = CountryCell(style: .default, reuseIdentifier: "CountryCell", country: countries[indexPath.row])
      return newCell
    }
    cell.configure(with: countries[indexPath.row])
    return cell
  }
}

// MARK: - UITableViewDelegate
extension CountriesListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let country = countries[indexPath.row]
    var detailsVC: CountryDetailsViewControllerProtocol = CountryDetailsViewController()
    detailsVC.country = country
    navigationController?.pushViewController(detailsVC as! UIViewController, animated: true)
  }
  
  func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let action = UIContextualAction(style: .normal, title: "isFavorite") { [unowned self] _, _, _ in
      var isFavorite = StorageManager.shared.getFavoriteStatus(for: countries[indexPath.row].name.common)
      isFavorite.toggle()
      StorageManager.shared.setFavoriteStatus(for: countries[indexPath.row].name.common, with: isFavorite)
      tableView.reloadRows(at: [indexPath], with: .fade)
    }
    return UISwipeActionsConfiguration(actions: [action])
  }
}

// MARK: - Setup Constraints
extension CountriesListViewController {
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
    ])
  }
}
