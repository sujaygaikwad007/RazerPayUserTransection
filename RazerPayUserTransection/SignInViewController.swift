
import UIKit
import Firebase

class SignInViewController: UIViewController {
    
    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    var userEmail = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        txtUsername.text = userEmail
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
                
                print("Welcome----")
                let welcomeVC = self.storyboard?.instantiateViewController(withIdentifier: "Welcome") as! Welcome
                self.navigationController?.pushViewController(welcomeVC, animated: true)
                
                self.txtUsername.text = ""
                self.txtPassword.text = ""
                
            }
        }
    }
    
    
}
