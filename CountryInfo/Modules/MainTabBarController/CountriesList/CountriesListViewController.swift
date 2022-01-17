//
//  CountriesListViewController.swift
//  CountryInfo
//
//  Created by Евгений Карпов on 06.01.2022.
//

import UIKit

class CountriesListViewController: UIViewController {
  
  // MARK: - Properties
  private let tableView = UITableView()
  private var didSetupConstraints = false
  private var viewModel: CountryListViewModelProtocol! {
    didSet {
      viewModel.fetchCountries { [unowned self] in
        self.tableView.reloadData()
      }
    }
  }
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel = CountryListViewModel()
    setupViews()
    setupSearchBar()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    tableView.reloadData()
  }
  
  override func updateViewConstraints() {
    super.updateViewConstraints()
    if !didSetupConstraints {
      view.backgroundColor = UIColor(red: 249/255, green: 250/255, blue: 253/255, alpha: 1)
      setupConstraints()
      didSetupConstraints = true
    }
  }
  
  // MARK: - Module functions
  private func setupViews() {
    title = "Country Info"
    tableView.dataSource = self
    tableView.delegate = self
    tableView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(tableView)
  }
  
  private func setupSearchBar() {
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationController?.navigationBar.tintColor = UIColor(red: 218/255, green: 64/255, blue: 122/255, alpha: 1)
    let searchController = UISearchController(searchResultsController: nil)
    navigationItem.hidesSearchBarWhenScrolling = false
    searchController.hidesNavigationBarDuringPresentation = true
    searchController.obscuresBackgroundDuringPresentation = false
    navigationItem.searchController = searchController
    searchController.searchBar.delegate = self
  }
}

// MARK: - UITableViewDataSource
extension CountriesListViewController: UITableViewDataSource {  
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
extension CountriesListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let detailsViewModel = viewModel.viewModelForSelectedRow(at: indexPath)
    var detailsViewController: CountryDetailsViewControllerProtocol = CountryDetailsViewController()
    detailsViewController.viewModel = detailsViewModel
    navigationController?.pushViewController(detailsViewController as! UIViewController, animated: true)
  }
  
  func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let action = UIContextualAction(style: .normal, title: "Follow") { [unowned self] _, _, _ in
      viewModel.toggleFavoriteStatus(at: indexPath)
      tableView.reloadRows(at: [indexPath], with: .fade)
    }
    if viewModel.returnFavoriteStatus(at: indexPath) {
      action.image = UIImage(systemName: "star.slash.fill")
      action.backgroundColor = UIColor(red: 243/255, green: 175/255, blue: 34/255, alpha: 1)
    } else {
      action.image = UIImage(systemName: "star.fill")
      action.backgroundColor = UIColor(red: 218/255, green: 64/255, blue: 122/255, alpha: 1)
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

// MARK: - UISearchBarDelegate

extension CountriesListViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    viewModel.search(with: searchText) { [unowned self] in
      tableView.reloadData()
    }
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    viewModel.cancelSearch { [unowned self] in
      tableView.reloadData()
    }
  }
}
