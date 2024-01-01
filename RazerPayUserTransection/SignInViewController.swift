
import UIKit
import Firebase

class SignInViewController: UIViewController {
    
    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    var userEmail = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txtUsername.text = userEmail

        
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            navigateToMainScreen()
        } else {
            self.txtUsername.text = !userEmail.isEmpty ? self.userEmail : ""
        }
        
    }
    
    
    @IBAction func signInBtnTapped(_ sender: Any)
    {
        firbaseSignIn()
    }
    
    func firbaseSignIn(){
        
        guard let email = txtUsername.text, let password = txtPassword.text else{
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            
            if let error = error{
                
                print("Error creating user: \(error.localizedDescription)")
            } else {
                
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                self.navigateToMainScreen()
                
                self.txtUsername.text = ""
                self.txtPassword.text = ""
                
            }
        }
    }
    
    
    func navigateToMainScreen() {
        if let uid = Auth.auth().currentUser?.uid {
            let welcomeVC = self.storyboard?.instantiateViewController(withIdentifier: "Welcome") as! WelcomeViewController

            self.navigationController?.pushViewController(welcomeVC, animated: true)
        }
    }
    
    
}

extension SignInViewController: WelcomeViewControllerDelegate {
    func didSignOut() {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
    }
}

