//
//  FavoriteCountriesViewController.swift
//  CountryInfo
//
//  Created by Евгений Карпов on 06.01.2022.
//

import UIKit

class FavoriteCountriesViewController: UIViewController {
  // MARK: - Properties
  private let tableView = UITableView()
  private var didSetupConstraints = false
  private var viewModel: FavoriteCountriesViewModelProtocol! {
    didSet {
      viewModel.fetchCountries { [unowned self] in
        self.tableView.reloadData()
      }
    }
  }
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel = FavoriteCountriesViewModel()
    setupViews()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    viewModel.checkFavoriteCountries()
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
    title = "Favorite Countries"
    tableView.dataSource = self
    tableView.delegate = self
    tableView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(tableView)
  }
}

// MARK: - UITableViewDataSource
extension FavoriteCountriesViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.numberOfRows()
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell") as? CountryTableViewCell  else {
      let cell = CountryTableViewCell(style: .default, reuseIdentifier: "CountryCell")
      cell.viewModel = viewModel.cellViewModel(at: indexPath)
      return cell
    }
    cell.viewModel = viewModel.cellViewModel(at: indexPath)
    return cell
  }
}

// MARK: - UITableViewDelegate
extension FavoriteCountriesViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let detailsViewModel = viewModel.viewModelForSelectedRow(at: indexPath)
    var detailsViewController: CountryDetailsViewControllerProtocol = CountryDetailsViewController()
    detailsViewController.viewModel = detailsViewModel
    navigationController?.pushViewController(detailsViewController as! UIViewController, animated: true)
  }
  
  func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let action = UIContextualAction(style: .normal, title: "isFavorite") { [unowned self] _, _, _ in
      viewModel.deleteFromFavorite(at: indexPath)
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

