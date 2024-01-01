
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import JGProgressHUD

class Welcome: UIViewController {
    
    
    @IBOutlet weak var tableData: UITableView!
    
    var users:[User] = []
    var jgProgrss : JGProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableData.dataSource = self
        tableData.delegate = self
        
        jgProgrss = JGProgressHUD(style:.dark)
        
        tableData.register(UINib(nibName: "ResultTableViewCell", bundle: .none), forCellReuseIdentifier: "ResultTableViewCell")
        
        fetchUserDetailsFromFirebase()
    }
    

    
    func fetchUserDetailsFromFirebase(){
        
        jgProgrss.show(in: self.view)
        
        let ref = Database.database().reference().child("users")
        
        ref.observe(.value) { [self] snapshot in
            self.users.removeAll()
            
            for child in snapshot.children {
                
                if let childSnapshot = child as? DataSnapshot,
                   let userData = childSnapshot.value as? [String: Any],
                   let username = userData["username"] as? String,
                   let email = userData["email"] as? String,
                   let uid = userData["uid"] as? String
                {
                    
                    let user = User(username: username, email: email, uid: uid)
                    print("user from database---\(user)")
                    self.users.append(user)
                }
            }
            
            self.users = self.users.filter { $0.uid != Auth.auth().currentUser?.uid}
            
            
            DispatchQueue.main.async {
                self.jgProgrss.dismiss(animated: true)
                self.tableData.reloadData()

            }
        }
    }
    

}


extension Welcome: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultTableViewCell", for: indexPath) as!
        ResultTableViewCell
        
        let user = users[indexPath.row]
        
        print("Username from table----\(user.username)")
        
        cell.lblUsername.text = user.username
        cell.lblUserEmail.text = user.email
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Razorpay---")
    }
}
