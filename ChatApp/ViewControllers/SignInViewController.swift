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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.layer.cornerRadius = 20
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
