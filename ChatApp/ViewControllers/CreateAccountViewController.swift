//
//  CreateAccountViewController.swift
//  ChatApp
//
//  Created by Gwinyai Nyatsoka on 21/7/2023.
//

import UIKit
import FirebaseAuth //for autorisation - go to firebase -> build -> authentication -> add auth type (our case set to email and password)
import FirebaseDatabase
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
      
      //MARK: - adding a link functionality to a attributed string creating a range of the string we need
      attributedString.addAttribute(.link, value: "chatappsignin://login", range: (attributedString.string as NSString).range(of:"Sign in here."))
      signinAccountTextView.linkTextAttributes = [.foregroundColor: UIColor.secondary, .font: Font.linkFont] //applying the linkcolor to the entire with textview.linktextattributes function
      signinAccountTextView.delegate = self
      signinAccountTextView.isEditable = false
      signinAccountTextView.isScrollEnabled = false
      let paragrapghStyle = NSMutableParagraphStyle() //making sure its mutable!!!in order to work with text properties/functions
      paragrapghStyle.alignment = .center
      attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragrapghStyle, range: .init(location: 0, length: attributedString.length))
      signinAccountTextView.attributedText = attributedString
      
      emailTextField.delegate = self
      passwordTextField.delegate = self
      usernameTextField.delegate = self
      
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
      view.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.layer.cornerRadius = 20
    }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    notificationSetup()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    dismissObservers()
  }
    
    @IBAction func createAccountButtonTapped(_ sender: Any) {
      //we creating a validation first!!! with unwrapping
      guard let username = usernameTextField.text, !username.isEmpty else {
        alert(title: "Error", message: "Please enter a username.")
        return
      }
      
      guard username.count >= 1 && username.count <= 15 else {
        alert(title: "Error", message: "Username must be between 1 and 15 characters.")
        return
      }
      
      guard let email = emailTextField.text, !email.isEmpty else {
        alert(title: "Error", message: "Please enter an email.")
        return
      }
      
      func isValidEmail(_ email: String) -> Bool {
          // 1️⃣ Define a regular expression (regex) that matches a “valid-looking” email
          // Breakdown of the regex:
          // [A-Z0-9a-z._%+-]+     → one or more characters that can be uppercase, lowercase, digits, dot, underscore, percent, plus, or minus (the local part before @)
          // @                     → must have a single @ symbol
          // [A-Za-z0-9.-]+        → one or more letters, digits, dots, or hyphens (the domain name)
          // \\.                   → a literal dot (escaped because . has special meaning in regex)
          // [A-Za-z]{2,}          → the domain extension must have at least 2 letters (like com, org, io)
          let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
          
          // 2️⃣ Create an NSPredicate that can evaluate whether a string matches the regex
          // "SELF MATCHES %@" → checks if the entire string matches the pattern
          let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
          
          // 3️⃣ Evaluate the email string against the regex
          // Returns true if it matches, false otherwise
          return predicate.evaluate(with: email)
      }

      
      guard isValidEmail(email) else {
        alert(title: "Error", message: "Please enter a valid email.")
        return
      }
      
      guard let password = passwordTextField.text, !password.isEmpty, password.count >= 6 else {
        alert(title: "Error", message: "Please enter a password with at least 6 characters.")
        return
      }
      
      print("Creating account for \(username), email: \(email), password: \(password)")
      
      //save data to firebase
//MARK: - create a database in firebase -> build -> realtime Database (no sql db storing string without any requerment and rules like sql does)
      Auth.auth().createUser(withEmail: email, password: password) { result, error in
        if let error = error {
          //adding self in front of the methods as those belong to ViewController not the specific closure so FireBase in our case doesnt know what are those and throw errors as it doesnt belong to VController
          print(error.localizedDescription)
          self.alert(title: "Error", message: error.localizedDescription)
          return
        }
        

        guard let result = result else {
          self.alert(title: "Error", message: "Something went wrong")
          return
        }
        
        //let uid = Auth.auth().currentUser?.uid
        let userId = result.user.uid
        let userData: [String: Any] = [
          "username": username,
          "uid": userId
          ]
        Database.database().reference().child("users").child(userId).setValue(userData) //will save data to the specific account you have created with specific id already created to prevent autogeneration again in db(so basically we would have one record in realtime database responding to the id created when new user was added during the authentication in users tab firebase)
        
//MARK: - Usually after login/signUp we redirect the user to new controller and killing the previous one by asigning and new controller as a root
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = mainStoryBoard.instantiateViewController(identifier: "HomeViewController")//main controller is in navigation stack!!!! so all controller are stucked on top of homeVC
        let navVC = UINavigationController(rootViewController: homeVC)
        //bellow we are serchin for all active (not nill windows) using flatMap
        let window = UIApplication.shared.connectedScenes.flatMap{ ($0 as? UIWindowScene)?.windows ?? [] }.first { $0.isKeyWindow }
        window?.rootViewController = navVC
        
        
      }//closure Auth()
      
    }//createAccountButtonTapped
  
  
  func notificationSetup() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIWindow.keyboardWillShowNotification, object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIWindow.keyboardWillHideNotification, object: nil)
  }
  
  func dismissObservers() {
    NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillHideNotification, object: nil)
    
    NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillShowNotification, object: nil)
  }
  
  @objc func keyboardWillShow(notification: NSNotification) {
    guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
    let keyboardHeight = view.convert(keyboardFrame.cgRectValue, from: nil).height
    let totalOffset = activeTextField == nil ? keyboardHeight : keyboardHeight + activeTextField!.frame.height + 5
    scrollView.contentInset.bottom = totalOffset
    
  }
  
  @objc func keyboardWillHide(notification: NSNotification) {
    scrollView.contentInset.bottom = 0
  }
    
  @objc func dismissKeyboard() {
    view.endEditing(true)
  }

}


//MARK: - using the delegate in order to apply the link functionality to a part of a textView
extension CreateAccountViewController: UITextViewDelegate {
  
  func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
    if URL.scheme == "chatappsignin" {
      performSegue(withIdentifier: "SignInSegue", sender: nil)
    }
    return false
  }
  
  
}

extension CreateAccountViewController:UITextFieldDelegate{
  func textFieldDidBeginEditing(_ textField: UITextField) {
    activeTextField = textField
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    activeTextField = nil
  }
}
