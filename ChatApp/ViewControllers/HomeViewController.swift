//
//  HomeViewController.swift
//  ChatApp
//
//  Created by Gwinyai Nyatsoka on 21/7/2023.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
  
  @IBAction func profileTapped(_ sender: Any) { 

    performSegue(withIdentifier: "profileSegue", sender: nil)
    
  }
  
  
}
