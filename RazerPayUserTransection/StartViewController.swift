import UIKit

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    @IBAction func signInBtn(_ sender: UIButton) {
        
        let signInVc = storyboard?.instantiateViewController(withIdentifier:"SignInViewController" ) as! SignInViewController
        self.navigationController?.pushViewController(signInVc, animated: true)
        
    }
    
    @IBAction func signUpBtn(_ sender: UIButton) {
        let signUpVc = storyboard?.instantiateViewController(withIdentifier:"SignUpViewController" ) as! SignUpViewController
        self.navigationController?.pushViewController(signUpVc, animated: true)
    }
    
}

