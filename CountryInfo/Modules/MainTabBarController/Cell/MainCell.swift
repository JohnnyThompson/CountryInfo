//
//  MainCell.swift
//  CountryInfo
//
//  Created by Евгений Карпов on 09.01.2022.
//

import UIKit


protocol CountryCellDelegate: AnyObject {
  func favoriteButtonPressed()
}

class CountryCell: UITableViewCell {
  
  // MARK: - Properties
  var isFavoriteButton = UIButton()
  var countryName = UILabel()
  weak var delegate: CountryCellDelegate?
  var isFavorite = false
  
  // MARK: - Initialization
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }
  
  convenience init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, country: Country) {
    self.init(style: style, reuseIdentifier: reuseIdentifier)
    configure(with: country)
    setupConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Public functions
  @objc func favoriteButtonTapped() {
    delegate?.favoriteButtonPressed()
  }
  
  func configure(with country: Country) {
    isFavoriteButton.setImage(UIImage(systemName: "star.fill") ?? UIImage(), for: .normal)
    loadFavorite(for: country)
//    isFavoriteButton.tintColor = .gray
//    if let isFavorite = country.isFavorite {
      isFavoriteButton.tintColor = isFavorite ? .red : .gray
//    }
    countryName.text = country.name.common
    countryName.textAlignment = .left
  }
  
  private func loadFavorite(for country: Country) {
    isFavorite = StorageManager.shared.getFavoriteStatus(for: country.name.common)
  }
}


extension CountryCell {
  private func setupConstraints() {
    countryName.setContentHuggingPriority(UILayoutPriority(rawValue: 1), for: .horizontal)
    isFavoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    let stackView = UIStackView(arrangedSubviews: [countryName, isFavoriteButton],
                                axis: .horizontal,
                                spacing: 10)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(stackView)
    
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
      stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
      stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
      stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16)
    ])
  }
}

import SwiftUI

struct SelfViewControllerProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let tabBarVC = MainTabBarController()
        
        func makeUIViewController(context: Context) -> some UIViewController {
            return tabBarVC
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
    }
}
