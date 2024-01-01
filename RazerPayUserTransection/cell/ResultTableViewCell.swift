

import UIKit

class ResultTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lblUsername: UILabel!
    
    @IBOutlet weak var lblUserEmail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainView.layer.cornerRadius = 20.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
