//
//  SignInViewController.swift
//  ChatApp
//
//  Created by Gwinyai Nyatsoka on 21/7/2023.
//

import UIKit

private extension NSRange {
    func toOptionalRange(in string: String) -> Range<String.Index>? {
        guard location != NSNotFound else { return nil }
        return Range(self, in: string)
    }
}

class SignInViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var createAccountTextView: UITextView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    var activeTextField: UITextField? //holding the active textfield property!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configure rounded corners
        containerView.clipsToBounds = true
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
      
      
        let attributedString = NSMutableAttributedString(string: "Don't have an account? Create an account here.", attributes: [
          .font: Font.caption
        ])
      attributedString.addAttribute(.link, value: "chatappsignin://signinAccount", range: (attributedString.string as NSString).range(of: "Create an account here."))
      createAccountTextView.linkTextAttributes = [.foregroundColor: UIColor.secondary, .font: Font.linkLabel]
      emailTextField.layer.masksToBounds = true
      passwordTextField.layer.masksToBounds = true
      createAccountTextView.delegate = self
      createAccountTextView.isScrollEnabled = false
      emailTextField.delegate = self
      passwordTextField.delegate = self
//MARK: - to cented attributed text you must use paragraphstyle()
      
      let p = NSMutableParagraphStyle()
      ///creating variable for the entire string length from 0 index to length of the string
      let wholeRange = NSRange(location: 0, length: attributedString.length)
      ///alighning out text inside the p to center
      p.alignment = .center
      /// adding attribute to the string with .paragraphstyle, value of p to the entire string (wholeRange)
      attributedString.addAttribute(.paragraphStyle, value: p, range: wholeRange)
      
      createAccountTextView.attributedText = attributedString
      createAccountTextView.isEditable = false //to prevent text inside the textView to be scrollable to prevent UX conflicts
      let backgroundTap = UITapGestureRecognizer(target: self, action: #selector(dismisKeyboard))
      view.addGestureRecognizer(backgroundTap)//adding the tap recogniser to entire view
    }
    
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    registerKeyboardNotifications()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    removeKeyboardNotifications() //we need to make sure to remove the observers when view is closed otherwise memory will be taken by this observers throughout the entire app!!!
  }
  
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.layer.cornerRadius = 20
      emailTextField?.layer.cornerRadius = 10
      passwordTextField.layer.cornerRadius = 10
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
    @IBAction func signinButtonTapped(_ sender: Any) {
        
    }

}

extension SignInViewController: UITextViewDelegate {
  func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
    if URL.scheme == "chatappsignin" {
      performSegue(withIdentifier: "CreateAccountSegue", sender: nil)
      
    }
    return false
  }
}
///TextFieldDelegate responsible for active texftfield
extension SignInViewController: UITextFieldDelegate {
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
