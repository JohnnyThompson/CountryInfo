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
    officialNameLabel = UILabel(text: country.name.official, font: .avenir26())
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
    view.addSubviews([flagImage, officialNameLabel, regionNameLabel, capitalLabel, populationLabel, timeZoneLabel])
  }
}

// MARK: - Setup Constraints

extension CountryDetailsViewController {
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      flagImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
      flagImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      flagImage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
      flagImage.heightAnchor.constraint(equalToConstant: 150),
      
      officialNameLabel.topAnchor.constraint(equalTo: flagImage.bottomAnchor, constant: 25),
      officialNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      officialNameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
      
      regionNameLabel.topAnchor.constraint(equalTo: officialNameLabel.bottomAnchor, constant: 16),
      regionNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      regionNameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
      
      capitalLabel.topAnchor.constraint(equalTo: regionNameLabel.bottomAnchor, constant: 16),
      capitalLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      capitalLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
      
      populationLabel.topAnchor.constraint(equalTo: capitalLabel.bottomAnchor, constant: 16),
      populationLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      populationLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
      
      timeZoneLabel.topAnchor.constraint(equalTo: populationLabel.bottomAnchor, constant: 16),
      timeZoneLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      timeZoneLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
    ])
  }
}
