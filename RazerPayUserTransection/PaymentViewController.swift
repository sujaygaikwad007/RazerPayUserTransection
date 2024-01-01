import UIKit
import Razorpay

class PaymentViewController: UIViewController {

    
    @IBOutlet weak var txtAmount: UITextField!
    
    @IBOutlet weak var paymentBtn: UIButton!
    
    var razerPayKey = "rzp_test_Whae1nSIWphn9n"
    var username = "", userEmail = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func paymentBtn(_ sender: UIButton) {
        
        guard  let amountString = txtAmount.text,
               let amount = Double(amountString) else{
                   
                        return
        }
        
        startRazerPay(amount: amount)
        txtAmount.text = ""
        
    }
    
    func startRazerPay(amount: Double){
        
        let razerPay = RazorpayCheckout.initWithKey(razerPayKey, andDelegate: self)
        
        let options: [String:Any] = [
                            "name": username,
                            "description": "User Payment",
                            "image": "https://www.smilefoundationindia.org/wp-content/uploads/2022/09/SMILE-FOUNDATION-LOGO-e1662456150120-1.png",
                            "currency": "INR",
                            "amount": amount * 100,
                            "prefill": [
                                "email": userEmail,
                                "contact": "9876543210"
                            ],
                            "theme": [
                                "color": "#000"
                            ]
                        ]
                        
                razerPay.open(options)
    }


}


extension PaymentViewController: RazorpayPaymentCompletionProtocol {
    func onPaymentSuccess(_ payment_id: String) {
        print("Payment Success: \(payment_id)")
    }
    
    func onPaymentError(_ code: Int32, description str: String) {
        
        print("Payment Error: \(code) - \(str)")
    }
}
