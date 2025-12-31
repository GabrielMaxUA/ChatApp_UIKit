//
//  SignInViewController.swift
//  ChatApp
//
//  Created by Gwinyai Nyatsoka on 21/7/2023.
//

import UIKit

class SignInViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var createAccountTextView: UITextView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    var activeTextField: UITextField?
  
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.clipsToBounds = true
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
      
      let attributedString = NSMutableAttributedString(string: "Don't have an account? Create an account here.", attributes: [
        .font: Font.caption
      ])
      
      //MARK: - adding a link functionality to a attributed string creating a range of the string we need
      attributedString.addAttribute(.link, value: "chatappcreate://createAccount", range: (attributedString.string as NSString).range(of:"Create an account here."))
      createAccountTextView.linkTextAttributes = [.foregroundColor: UIColor.secondary, .font: Font.linkFont] //applying the linkcolor to the entire with textview.linktextattributes function
      createAccountTextView.delegate = self
      createAccountTextView.isEditable = false
      createAccountTextView.isScrollEnabled = false
      let paragrapghStyle = NSMutableParagraphStyle() //making sure its mutable!!!in order to work with text properties/functions
      paragrapghStyle.alignment = .center
      attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragrapghStyle, range: .init(location: 0, length: attributedString.length))
      createAccountTextView.attributedText = attributedString
      emailTextField.delegate = self
      passwordTextField.delegate = self
      let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
      view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.layer.cornerRadius = 20
    }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    notificatioCenter()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    dismissNotiification()
  }
  
  func notificatioCenter() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIWindow.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIWindow.keyboardWillHideNotification, object: nil)
  }
  
  func dismissNotiification() {
    NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillHideNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillShowNotification, object: nil)
  }
  
  @objc func dismissKeyboard () {
    view.endEditing(true)
  }
  
  @objc func keyboardWillShow(notification: Notification) {
    guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
    
    let keyboardHeight = view.convert(keyboardFrame.cgRectValue, to: nil).height
    let totalOffset = activeTextField == nil ? keyboardHeight + 5 : keyboardHeight + activeTextField!.frame.height + 5
    //same as above
  /*
     var totalOffset: CGFloat

     if activeTextField == nil {
         totalOffset = keyboardHeight + 5
     } else {
         totalOffset = keyboardHeight + activeTextField!.frame.height + 5
     }

  */
    scrollView.contentInset.bottom = totalOffset
  }
  
  @objc func keyboardWillHide(notification: Notification) {
    scrollView.contentInset.bottom = 0
  }

    @IBAction func signinButtonTapped(_ sender: Any) {
        
    }

}


//MARK: - using the delegate in order to apply the link functionality to a part of a textView
extension SignInViewController: UITextViewDelegate {
  
  func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
    if URL.scheme == "chatappcreate" {
      performSegue(withIdentifier: "CreateAccountSegue", sender: nil)
    }
    return false
  }
  
  
}

extension SignInViewController: UITextFieldDelegate {
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    activeTextField = textField
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    activeTextField = nil
  }
}
