//
//  LoginViewController.swift
//  ShoppingList
//
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var labelCopyright: UILabel!
    @IBOutlet weak var buttonSignup: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let _ = Auth.auth().currentUser {
            guard let listTableViewController = storyboard?.instantiateViewController(withIdentifier: "ListTableViewController") else { return }
            navigationController?.pushViewController(listTableViewController, animated: false)
        }
    }
    
    @IBAction func signIn(_ sender: Any) {
        Auth.auth().signIn(withEmail: textFieldEmail.text!, password: textFieldPassword.text!) {
            result, error in
            
            guard let user = result?.user else { return }
            self.updateUserAndProceed(user: user)
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
      Auth.auth().createUser(withEmail: textFieldEmail.text!, password: textFieldPassword.text!) { result, error in
            if let error = error {
                let authErrorCode = AuthErrorCode ( rawValue: error._code)
                switch authErrorCode {
                case .emailAlreadyInUse:
                    print("Email em uso")
                case .weakPassword:
                    print("A senha escolhida nao é forte")
                default:
                    print(authErrorCode)
                }
            } else {
                if let user = result?.user {
                    self.updateUserAndProceed(user:user)
                }
                
            }
        }
        	
    }
    
    func gotoMainScreen(){
        guard let listTableViewController = storyboard?.instantiateViewController(withIdentifier: "ListTableViewController") else { return }
        show(listTableViewController, sender: nil)
    }
    
    func updateUserAndProceed(user: User){
        if textFieldName.text!.isEmpty {
            gotoMainScreen()
        } else {
            let request = user.createProfileChangeRequest()
            request.displayName = textFieldName.text!
            request.commitChanges { _ in
                self.gotoMainScreen()
            }
        }
    }
    
}

