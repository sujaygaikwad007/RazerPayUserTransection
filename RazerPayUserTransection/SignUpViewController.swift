import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var txtSignUpUsername: UITextField!
    @IBOutlet weak var txtSignUpEmail: UITextField!
    @IBOutlet weak var txtSignUpPassword: UITextField!
    @IBOutlet weak var txtSignUpConfirmPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    @IBAction func signUpBtnTapped(_ sender: Any) {
        
        firebaseSignUp()
        
    }
    
    func firebaseSignUp() {
        guard let email = txtSignUpEmail.text, let password = txtSignUpConfirmPassword.text, let username = txtSignUpUsername.text else {
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error creating user: \(error.localizedDescription)")
            } else if let user = Auth.auth().currentUser {
                let userRef = Database.database().reference().child("users").child(user.uid)
                
                let userDetails: [String: Any] = [
                    "uid": user.uid,
                    "username": username,
                    "email": email,
                ]
                
                userRef.setValue(userDetails) { (error, ref) in
                    if let error = error {
                        print("Error storing user details: \(error.localizedDescription)")
                    } else {
                        print("Database updated successfully after user created account")
                        
                let signInVc = self.storyboard?.instantiateViewController(withIdentifier:"SignInViewController") as! SignInViewController
                        signInVc.userEmail = self.txtSignUpEmail.text!
                self.navigationController?.pushViewController(signInVc, animated: true)
                self.textFieldClearFunc()
                    }
                }
            }
        }
    }
    
    
    func textFieldClearFunc()
    {
        txtSignUpUsername.text = ""
        txtSignUpEmail.text =  ""
        txtSignUpPassword.text = ""
        txtSignUpConfirmPassword.text = ""
    }
    
    
    
    
}
