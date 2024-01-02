import UIKit
import Razorpay
import Firebase
import MessageKit
import InputBarAccessoryView

class PaymentViewController: MessagesViewController {
    
    var razerPayKey = "rzp_test_Whae1nSIWphn9n"
    var username = ""
    var userEmail = ""
    var receiverUid = ""
    
    var messages = [Message]()
    
    let selfSender = Sender(senderId: Auth.auth().currentUser!.uid,
                            displayName: Auth.auth().currentUser!.displayName ?? "Anonymous")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        configureMessageInputBar()
        observeMessages()

    }
    
    
    func configureMessageInputBar() {
        messageInputBar.delegate = self
        messageInputBar.inputTextView.placeholder = "Enter an amount"
        messageInputBar.sendButton.setTitle("Pay", for: .normal)
    }
    
    
    // payment method start---
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
    // payment method end------

    
    
    //to get message from database observer method start----
    func observeMessages() {
        guard let user = Auth.auth().currentUser else { return }
        
        let senderId = user.uid
        let chatId = receiverUid
        
        print("observeMessages Sender UID is--------\(user.uid)")
        print("observeMessages Receiver UID is------\(receiverUid)")
        
        let ref = Database.database().reference().child("users").child(senderId).child(chatId).child("messages")
        
        ref.observe(.childAdded) { [weak self] snapshot in
            guard let self = self else { return }
            
            if let messageData = snapshot.value as? [String: Any],
               let senderId = messageData["senderId"] as? String,
               let displayName = messageData["displayName"] as? String,
               let text = messageData["text"] as? String,
               let timestamp = messageData["timestamp"] as? TimeInterval
            {
                let sender = Sender(senderId: senderId, displayName: displayName)
                print("Sender is-----\(sender)")
                
                let message = Message(sender: sender, messageId: snapshot.key, sentDate: Date(timeIntervalSince1970: timestamp), kind: .text(text))
                print("observeMessages Message is------\(message)")
                
                self.messages.append(message)
                
                DispatchQueue.main.async {
                    self.messagesCollectionView.reloadData()
                }
            }
            else {
                print("could not print timestamp----")
            }
        }
    }
    //observer method end---
}



extension PaymentViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> SenderType {
        return selfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func isFromCurrentSender(message: MessageType) -> Bool {
        return message.sender.senderId == selfSender.senderId
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


extension PaymentViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard let amountString = messageInputBar.inputTextView.text,
              let amount = Double(amountString) else {
            return
        }
        startRazerPay(amount: amount)
        sendMessage(text: text)
        inputBar.inputTextView.text = ""
    }
}


extension PaymentViewController {
    
    func sendMessage(text: String) {
        sendToUser(text: text)
        if selfSender.senderId == Auth.auth().currentUser?.uid {
            sendFromUser(text: text)
        }
    }
    
    func sendToUser(text: String) {
        
        guard let user = Auth.auth().currentUser else { return }
        let senderId = user.uid
        let receiverId = receiverUid
        
        print("SendToUser Sender UID is--------\(user.uid)")
        print("SendToUser Receiver UID is------\(receiverUid)")
        
        let receiverRef = Database.database().reference().child("users").child(senderId).child(receiverId).child("messages")
        
        let messageData: [String: Any] = [
            "senderId": user.uid,
            "displayName": user.displayName ?? "",
            "text": text,
            "timestamp": ServerValue.timestamp()
        ]
        
        receiverRef.childByAutoId().setValue(messageData) { (error, _) in
            if let error = error {
                print("Error sending message to receiver: \(error.localizedDescription)")
            }
        }
    }
    
    func sendFromUser(text: String) {
        guard let user = Auth.auth().currentUser else { return }
        let senderId = user.uid
        let receiverId = receiverUid
        
        print("sendFromUser Sender UID is--------\(user.uid)")
        print("sendFromUser Receiver UID is------\(receiverUid)")
        
        let senderRef = Database.database().reference().child("users").child(receiverId).child(senderId).child("messages")
        
        let messageData: [String: Any] = [
            "senderId": user.uid,
            "displayName": user.displayName ?? "",
            "text": text,
            "timestamp": ServerValue.timestamp()
        ]
        
        senderRef.childByAutoId().setValue(messageData) { (error, _) in
            if let error = error {
                print("Error sending message to sender: \(error.localizedDescription)")
            }
        }
    }
}
