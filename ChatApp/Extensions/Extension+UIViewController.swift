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

  
  func showLoading() {
    let loadingView = LoadingView()
    view.addSubview(loadingView)//adding the view to the subviews
    loadingView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
    //creating a tag to this view in order to find it in a superView
    loadingView.tag = 2026
  }
  
  func removeLoadinView() {
    if let loadingView = view.viewWithTag(2026) {
      loadingView.removeFromSuperview()
    } else {
      alert(title: "Error", message: "Something went wrong?")
    }
  }
  
}
