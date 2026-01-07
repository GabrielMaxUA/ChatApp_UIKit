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
    } //didLoad()
    
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
      
      
      //MARK: - methods below already exists and provided by FIREBASE
      
//      func isValidEmail(_ email: String) -> Bool {
//          // 1️⃣ Define a regular expression (regex) that matches a “valid-looking” email
//          // Breakdown of the regex:
//          // [A-Z0-9a-z._%+-]+     → one or more characters that can be uppercase, lowercase, digits, dot, underscore, percent, plus, or minus (the local part before @)
//          // @                     → must have a single @ symbol
//          // [A-Za-z0-9.-]+        → one or more letters, digits, dots, or hyphens (the domain name)
//          // \\.                   → a literal dot (escaped because . has special meaning in regex)
//          // [A-Za-z]{2,}          → the domain extension must have at least 2 letters (like com, org, io)
//          let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
//          
//          // 2️⃣ Create an NSPredicate that can evaluate whether a string matches the regex
//          // "SELF MATCHES %@" → checks if the entire string matches the pattern
//          let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
//          
//          // 3️⃣ Evaluate the email string against the regex
//          // Returns true if it matches, false otherwise
//          return predicate.evaluate(with: email)
//      }
//
//      
//      guard isValidEmail(email) else {
//        alert(title: "Error", message: "Please enter a valid email.")
//        return
//      }
      
      
      guard let password = passwordTextField.text, !password.isEmpty, password.count >= 6 else {
        alert(title: "Error", message: "Please enter a password with at least 6 characters.")
        return
      }
      
      //showing loadingView
      showLoading()
      
      checkIfExist(username: username) { [weak self] userNameExists in
        //without capture list [weak self] ASTRONG REFERENCE MOST LIKELY CREATED AND WE NEED TO CREATE A CAPTURE LIST TO KILL THE PROCESS AFTER SUCCESS TO FREE UP THE MEMORY WHEN VC IS CHANGED by addinf [weak self]/[unowned self] to a closure parameteres. weak self is preferable while unowned self we need to make sure that self won't become nil!!!
        guard let strongSelf = self else { return } //making sure weak self isnt nil so no strong reference will be made and clogg the memory...
        if !userNameExists {
          strongSelf.createUser(username: username, email: email, password: password) { result ,error in
//MARK: - results from Firebase are all returned to a mainthread so we can update the ui and we dont need to safeguard the variables/results in:
           /* if let error = error {
              DispatchQueue.main.async {
                self.alert(title: "Oops!", message: error)
              }
              return
            } */
            if let error = error {
              strongSelf.alert(title: "Oops!", message: error)
              return
            }
            guard let result = result else {
              strongSelf.alert(title: "Oops!", message: "Please try again later")
              return }
            let userId = result.user.uid
            let userData: [String: Any] = [
              "username": username,
              "uid": userId
              ]
            
            Database.database().reference().child("users").child(userId).setValue(userData) //will save data to the specific account you have created with specific id already created to prevent autogeneration again in db(so basically we would have one record in realtime database responding to the id created when new user was added during the authentication in users tab firebase)
           /*
            reference() -> pointing to fire database
            child("users"), child("passwords") -> creating the array/folder of users/passwords inside the realtime db
            child(userId) -> creating a new record for the specific userID you just created during authorization/ if not pointing then new id will be generated not same as the one user already have - issue when fetching data checking if user already exists in the system?
            setValue(userData) -> saving the data inside the new record
          */
            Database.database().reference().child("usernames").child(username).setValue(userData)//saving the usernames in the database "folder"
            
//MARK: - for convinience we implement the createProfileChangeReuest in order to use the username
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = username
            changeRequest?.commitChanges()
            
//MARK: - Usually after login/signUp we redirect the user to new controller and killing the previous one by asigning and new controller as a root
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            
            let homeVC = mainStoryBoard.instantiateViewController(identifier: "HomeViewController")//main controller is in navigation stack!!!! so all controller are stucked on top of homeVC
            let navVC = UINavigationController(rootViewController: homeVC) //main Storyboard wrapt in navigation controller.
            
            //bellow we are serchin for all active (not nill windows) using flatMap
            let window = UIApplication.shared.connectedScenes.flatMap{ ($0 as? UIWindowScene)?.windows ?? [] }.first { $0.isKeyWindow }
            
            window?.rootViewController = navVC
          }
        } else {
          strongSelf.alert(title: "Oops!", message: "This username is already taken.")
          strongSelf.removeLoadinView()
        }
      }//checkIfExists
      
      print("Creating account for \(username), email: \(email), password: \(password)")
     
      
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

  
  func checkIfExist(username: String, completionHandler: @escaping (_ result: Bool) -> Void) {
    
    //MARK: - below we are checking if the username already exist in the database usernames "folder" before we are saving the data
          Database.database().reference().child("usernames").child(username).observeSingleEvent(of: .value) { snapshot in
            guard !snapshot.exists()  else {
              completionHandler(true)
              return
            }
            completionHandler(false)
          }//database check on existanse of the username in the database and saving it to firebase
  }//checkIfExist()
  
  func createUser(username: String, email: String, password: String, completionHandler: @escaping (_ result: AuthDataResult?, _ error: String?) -> Void) {
//MARK: - create a database in firebase -> build -> realtime Database (no sql db storing string without any requerment and rules like sql does)
          Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let strongSelf = self else { return } //unwrapping weak self before using it to make sure its not nil
            strongSelf.removeLoadinView()//STRONG REFERENCE MOST LIKELY CREATED AND WE NEED TO CREATE A CAPTURE LIST in @escaping closures!!!! TO KILL THE PROCESS AFTER SUCCESS TO FREE UP THE MEMORY WHEN VC IS CHANGED by addinf [weak self]/[unowned self] to a closure parameteres. weak self is preferable while unowned self we need to make sure that self won't become nil!!!
            
            if let error = error {
              //adding self in front of the methods as those belong to ViewController not the specific closure so FireBase in our case doesnt know what are those and throw errors as it doesnt belong to VController
              print(error.localizedDescription)
              var errorMessage = "Something went wrong. Please try again later."
              //trying to translate the error code from FIREBASE
              if let authError = AuthErrorCode(rawValue: error._code) {
                switch authError {
                case .emailAlreadyInUse:
                  errorMessage = "The email you provided is already in use."
                case .invalidEmail:
                  errorMessage = "The email you provided is invalid."
                case .networkError:
                  errorMessage = "There seems to be a problem with the internet connection. Please try again later."
                case .weakPassword:
                  errorMessage = "The password you provided is too weak. Please try a stronger password."
                default:
                  break
                }
              }
              completionHandler(nil, errorMessage)
              return
            }
            

            guard let result = result else {
              completionHandler(nil, "Something went wrong. Please try again later.")
              return
            }
            
            completionHandler(result, nil)
          
            
            
          }//closure Auth()
  }//createUser
  
}//class


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
