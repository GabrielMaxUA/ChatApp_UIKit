//
//  ProfileViewController.swift
//  ChatApp
//
//  Created by Max Gabriel on 2026-01-01.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
  
  @IBOutlet weak var profileContainer: UIView!
  @IBOutlet weak var avatarImage: UIImageView!
  @IBOutlet weak var usernameLabel: UILabel!
  

    override func viewDidLoad() {
        super.viewDidLoad()
      avatarImage.image = UIImage(systemName: "person.fill")
      avatarImage.tintColor = .gray
      avatarImage.layer.borderColor = UIColor.gray.cgColor
      avatarImage.layer.borderWidth = 1.0
      avatarImage.clipsToBounds = true
      avatarImage.backgroundColor = .lightGray
      let avatarTap = UITapGestureRecognizer(target: self, action: #selector(presentAvatarOption))
      avatarImage.addGestureRecognizer(avatarTap)
      avatarImage.isUserInteractionEnabled = true
    }
    
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    profileContainer.layer.cornerRadius = 8
    avatarImage.layer.cornerRadius = avatarImage.frame.width / 2
  }

  
  @IBAction func logoutTapped(_ sender: Any) {
      presentInfoAlert(title: "Logout", message: "Are you sure you want to logout?")
  }
  
  @IBAction func closeProfileTapped(_ sender: Any) {
    dismiss(animated: true)
  }
  
  func logout() {
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
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { _ in
      self.logout()
    }
    alert.addAction(cancelAction)
    alert.addAction(logoutAction)
    present(alert, animated: true, completion: nil)
  }

//MARK: - Action shit alert
  @objc func presentAvatarOption () {
    let avatarOptionSheet = UIAlertController(title: "Change avatar", message: "Select an option", preferredStyle: .actionSheet)
    let takePhotoAction = UIAlertAction(title: "Camera", style: .default) { _ in
      
    }
    let choosePhotoAction = UIAlertAction(title: "Photo Library", style: .default) { _ in
      
    }
    let removeAction = UIAlertAction(title: "Remove avatar", style: .destructive) { _ in
      
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    avatarOptionSheet.addAction(takePhotoAction)
    avatarOptionSheet.addAction(choosePhotoAction)
    avatarOptionSheet.addAction(removeAction)
    avatarOptionSheet.addAction(cancelAction)
    
    present(avatarOptionSheet, animated: true, completion: nil)
    
  }//presentAvarOption()
}//class
