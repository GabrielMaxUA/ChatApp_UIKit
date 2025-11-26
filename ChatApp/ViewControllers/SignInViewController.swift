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
      
  //MARK: - IF WE WANT TO CREATE AN ATTRIBUTED STRING inside the string
      
  /// we create the attributes string and apply mutable attributes to the entire string with desired attributes
      /// 
        let fullString = createAccountTextView.text!
        let targetText = "Create an account here."
      
        let attributedString = NSMutableAttributedString(
            string: fullString,
            attributes: [
                .font: UIFont.systemFont(ofSize: 14),
                .foregroundColor: UIColor.label
            ]
        )
      
  /// the we add additional attributes specifically to desired portion of a string inside the entire string with needed attributes like below USING RANGE OF DESIRED STRING DESLARED ABOVE INSIDE THE ENTIRE STRING)
      ///
      if let targetRange = fullString.range(of: targetText) {
        let nsRange = NSRange(targetRange, in: fullString)
        attributedString.addAttribute(
          .foregroundColor,
          value: UIColor.link,
          range: nsRange
        )
      }
      
        createAccountTextView.attributedText = attributedString
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.layer.cornerRadius = 20
    }

    @IBAction func signinButtonTapped(_ sender: Any) {
        
    }

}
