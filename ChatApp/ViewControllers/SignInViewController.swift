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
      createAccountTextView.delegate = self
      createAccountTextView.isScrollEnabled = false

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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.layer.cornerRadius = 20
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
