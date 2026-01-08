//
//  SignInViewController.swift
//  ChatApp
//
//  Created by Gwinyai Nyatsoka on 21/7/2023.
//

import UIKit
import FirebaseAuth

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
    } //keyboardWillShow
  
    @objc func keyboardWillHide(notification: Notification) {
      scrollView.contentInset.bottom = 0
    }

    @IBAction func signinButtonTapped(_ sender: Any) {
      guard let email = emailTextField.text, !email.isEmpty else {
        alert(title: "Error", message: "Please enter an email.")
        return
      }
      
      guard let password = passwordTextField.text, !password.isEmpty, password.count >= 6 else {
        alert(title: "Error", message: "Please enter a password with at least 6 characters.")
        return
      }
      showLoading()
      signinUser(email: email, password: password) { [weak self] success, error in
        guard let strongSelf = self else { return }
        
        if let error = error {
          print(error)
          strongSelf.alert(title: "Error", message: error)
          strongSelf.removeLoadinView()
          return
        }
        //navigating after signIn changing rootController after result came back as success from signinUser() completion request closure)
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = mainStoryBoard.instantiateViewController(withIdentifier: "HomeViewController")
        let navVC = UINavigationController(rootViewController: homeVC)
        let window = UIApplication.shared.connectedScenes.flatMap { ($0 as? UIWindowScene)?.windows ?? [] }.first { $0.isKeyWindow }
        window?.rootViewController = navVC
        
      }
    }//signinbuttontapped()

  func signinUser(email: String, password: String, completion: @escaping (_ success: Bool, _ error: String?) -> Void) {
    Auth.auth().signIn(withEmail: email, password: password) { _, error in
      //self.removeLoadinView()
      if let error = error {
          //adding self in front of the methods as those belong to ViewController not the specific closure so FireBase in our case doesnt know what are those and throw errors as it doesnt belong to VController
          print(error.localizedDescription)
          var errorMessage = "Something went wrong. Please try again later."
          //trying to translate the error code from FIREBASE
          if let authError = AuthErrorCode(rawValue: error._code) {
            switch authError {
            case .userNotFound:
              errorMessage = "We couldn't find an account with that email. Please try signing up instead."
            case .networkError:
              errorMessage = "There seems to be a problem with the internet connection. Please try again later."
            case .wrongPassword:
              errorMessage = "The password you provided isn't matching with what we have on record. Please try again."
            default:
              break
            }
          }
          completion(false, errorMessage)//error
          //self.alert(title: "Oops!", message: errorMessage)
          return
        }//error
      completion(true , nil) //success
      
    } //Auth.auth().signIn(withEmail: email, password: password)
  }//signinUser()
  
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
