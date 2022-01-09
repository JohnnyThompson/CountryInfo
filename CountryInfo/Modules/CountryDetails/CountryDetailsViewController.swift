//
//  CountryDetailsViewController.swift
//  CountryInfo
//
//  Created by Евгений Карпов on 06.01.2022.
//

import UIKit

protocol CountryDetailsViewControllerProtocol {
  var country: Country? { get set }
}

class CountryDetailsViewController: UIViewController, CountryDetailsViewControllerProtocol {
  
  // MARK: - Properties
  private var flagImage = UIImageView()
  private var officialNameLabel: UILabel!
  private var regionNameLabel: UILabel!
  private var capitalLabel: UILabel!
  private var populationLabel: UILabel!
  private var timeZoneLabel: UILabel!
  private var didSetupConstraints = false
  var country: Country?
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
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
    guard let country = country else {
      return
    }
    officialNameLabel = UILabel(text: country.name.official, font: .helveticaNeue26())
    officialNameLabel.textAlignment = .center
    regionNameLabel = UILabel(text: "Region: \(country.region)")
    capitalLabel = UILabel(text: "Capital: \(country.capital.first ?? "")")
    populationLabel = UILabel(text: "Population: \(country.population)")
    var timeZones: String = ""
    country.timezones.forEach {
        timeZones.append("\($0) ")
    }
    timeZoneLabel = UILabel(text: "Time zones: \(timeZones)")
    
    
    guard let imageData = ImageManager.shared.fetchImage(from: country.flags.png) else {
      flagImage.image = UIImage(systemName: "nosign") ?? UIImage()
      return
    }
    flagImage.image = UIImage(data: imageData)
    flagImage.contentMode = .scaleAspectFit
    view.addSubviews([flagImage, officialNameLabel])
  }
}

// MARK: - Setup Constraints

extension CountryDetailsViewController {
  private func setupConstraints() {
    let stackView = UIStackView(arrangedSubviews: [regionNameLabel, capitalLabel, populationLabel, timeZoneLabel],
                                axis: .vertical, spacing: 10)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(stackView)
    
    NSLayoutConstraint.activate([
      flagImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
      flagImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      flagImage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
      flagImage.heightAnchor.constraint(equalToConstant: 150),
      
      officialNameLabel.topAnchor.constraint(equalTo: flagImage.bottomAnchor, constant: 25),
      officialNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      officialNameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
      
      stackView.topAnchor.constraint(equalTo: officialNameLabel.bottomAnchor, constant: 16),
      stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
    ])
  }
}
