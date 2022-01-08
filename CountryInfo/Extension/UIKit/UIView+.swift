//
//  UIView+.swift
//  CountryInfo
//
//  Created by Евгений Карпов on 06.01.2022.
//

import UIKit

extension UIView {
  func addSubviews(_ views: [UIView]) {
    views.forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
  }
  
  func setDefaultLeadingTrailingConstraints(_ view: UIView, rootView: UIView) {
    NSLayoutConstraint.activate([
      view.leadingAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      view.trailingAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.trailingAnchor, constant: -16)
    ])
  }
}
