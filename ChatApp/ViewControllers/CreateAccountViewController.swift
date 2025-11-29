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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.layer.cornerRadius = 20
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
