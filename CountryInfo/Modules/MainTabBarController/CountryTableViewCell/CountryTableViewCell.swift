//
//  CountryTableViewCell.swift
//  CountryInfo
//
//  Created by Евгений Карпов on 09.01.2022.
//

import UIKit

class CountryTableViewCell: UITableViewCell {
  
  // MARK: - Properties
  var isFavoriteButton = UIButton()
  var countryName = UILabel()
  var viewModel: CountryTableViewCellViewModelProtocol! {
    didSet {
      setupView()
    }
  }
  
  // MARK: - Module functions
  private func setupView() {
    isFavoriteButton.setImage(UIImage(systemName: "star.fill"),
                              for: .normal)
    isFavoriteButton.tintColor = viewModel.favoriteButtonStatus ? .red : .gray
    
    countryName.text = viewModel.countryName
    countryName.setContentHuggingPriority(UILayoutPriority(rawValue: 1),
                                          for: .horizontal)
    
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

