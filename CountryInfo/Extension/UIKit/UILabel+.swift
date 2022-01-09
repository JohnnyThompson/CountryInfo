//
//  UILabel+.swift
//  CountryInfo
//
//  Created by Евгений Карпов on 07.01.2022.
//

import UIKit

extension UILabel {
  convenience init(text: String,
                   font: UIFont? = .helveticaNeue20()) {
    self.init()
    self.text = text
    self.font = font
    self.numberOfLines = 0
  }
}
