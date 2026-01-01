//
//  HomeViewController.swift
//  ChatApp
//
//  Created by Gwinyai Nyatsoka on 21/7/2023.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
  
  @IBAction func logoutTapped(_ sender: Any) {
    presentInfoAlert(title: "Logout", message: "Are you sure you want to logout?")
  }
  
  func completeLogout() {
    do {
      try Auth.auth().signOut()
      let authStoryboard = UIStoryboard(name: "Auth", bundle: nil)
      let signinVC = authStoryboard.instantiateViewController(withIdentifier: "SignInViewController")
      let window = UIApplication.shared.connectedScenes.flatMap{ ($0 as? UIWindowScene)?.windows ?? [] }.first { $0.isKeyWindow }
      
      window?.rootViewController = signinVC
    } catch {
      let error = error as NSError
      alert(title: "Error", message: "Error signing out: \(error.localizedDescription)")
    }
  }
  
  func presentInfoAlert (title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
    let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { _ in
      self.completeLogout() 
    }
    alert.addAction(cancelAction)
    alert.addAction(logoutAction)
    present(alert, animated: true, completion: nil)
  }
  
}
