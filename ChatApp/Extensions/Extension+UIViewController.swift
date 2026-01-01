//
//  Extension+UIViewController.swift
//  ChatApp
//
//  Created by Max Gabriel on 2025-12-30.
//

import Foundation
import UIKit

extension UIViewController {
  
  func alert(title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    present(alert, animated: true)
  }

}
