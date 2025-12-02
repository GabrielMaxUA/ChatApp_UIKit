//
//  CreateAccountViewController.swift
//  ChatApp
//
//  Created by Gwinyai Nyatsoka on 21/7/2023.
//

import UIKit

class CreateAccountViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signinAccountTextView: UITextView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    var activeTextField: UITextField?
  
  
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.clipsToBounds = true
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
      
        let attributedString = NSMutableAttributedString(string: "Already have an account? Sign in here.", attributes: [
          .font: Font.caption
        ])
        attributedString.addAttribute(.link, value: "chatappcreate://createAccount", range: (attributedString.string as NSString).range(of: "Sign in here."))
      signinAccountTextView.linkTextAttributes = [.foregroundColor: UIColor.secondary, .font: Font.linkLabel]
      signinAccountTextView.delegate = self
      signinAccountTextView.isScrollEnabled = false
      
//MARK: - to cented attributed text you must use paragraphstyle()
      
      let p = NSMutableParagraphStyle()
      ///creating variable for the entire string length from 0 index to length of the string
      let wholeRange = NSRange(location: 0, length: attributedString.length)
      ///alighning out text inside the p to center
      p.alignment = .center
      /// adding attribute to the string with .paragraphstyle, value of p to the entire string (wholeRange)
      attributedString.addAttribute(.paragraphStyle, value: p, range: wholeRange)
      
      signinAccountTextView.attributedText = attributedString
      signinAccountTextView.isEditable = false//to prevent text inside the textView to be scrollable to prevent UX conflicts
      usernameTextField.layer.masksToBounds = true
      emailTextField.layer.masksToBounds = true
      passwordTextField.layer.masksToBounds = true
      usernameTextField.delegate = self
      emailTextField.delegate = self
      passwordTextField.delegate = self
      
      let backgroundTap = UITapGestureRecognizer(target: self, action: #selector(dismisKeyboard))
      view.addGestureRecognizer(backgroundTap)//adding the tap recogniser to entire view
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.layer.cornerRadius = 20
      usernameTextField.layer.cornerRadius = 10
      emailTextField.layer.cornerRadius = 10
      passwordTextField.layer.cornerRadius = 10
    }
  
  
override func viewWillAppear(_ animated: Bool) {
  super.viewWillAppear(animated)
  registerKeyboardNotifications()
}

override func viewWillDisappear(_ animated: Bool) {
  super.viewWillDisappear(animated)
  removeKeyboardNotifications() //we need to make sure to remove the observers when view is closed otherwise memory will be taken by this observers throughout the entire app!!!
}


func registerKeyboardNotifications() {
  NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification: )), name: UIWindow.keyboardWillShowNotification, object: nil)
  NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification: )), name: UIWindow.keyboardWillHideNotification, object: nil)
}

func removeKeyboardNotifications() {
  NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillShowNotification, object: nil)
  NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillHideNotification, object: nil)
}

@objc func keyboardWillShow(notification: NSNotification) {
  print("keyboard shown")
  guard let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
    else { return }
  let keyboardOffset = view.convert(keyboardSize.cgRectValue, from: nil).size.height // assigning the keyboard frame
  let totalOffset = activeTextField == nil ? keyboardOffset : keyboardOffset + activeTextField!.frame.height
  scrollView.contentInset.bottom = totalOffset
}

@objc func keyboardWillHide(notification: NSNotification) {
  print("keyboard hidden")
  scrollView.contentInset.bottom = 0
}

@objc func dismisKeyboard() {
  view.endEditing(true)
}
    
    @IBAction func createAccountButtonTapped(_ sender: Any) {
    }
    

}


extension CreateAccountViewController: UITextViewDelegate {
  func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
    if URL.scheme == "chatappcreate" {
      performSegue(withIdentifier: "SignInSegue", sender: nil)
      
    }
    return false
  }
}


///TextFieldDelegate responsible for active texftfield
extension CreateAccountViewController: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    activeTextField = textField //asigning our variable to textfield
    activeTextField?.layer.borderWidth = 1.0
    activeTextField?.layer.cornerRadius = 10
    activeTextField?.layer.borderColor = UIColor.blue.cgColor
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    activeTextField?.layer.borderWidth = 0
    activeTextField?.layer.cornerRadius = 10
    activeTextField = nil //disabling active field
    
  }
}
