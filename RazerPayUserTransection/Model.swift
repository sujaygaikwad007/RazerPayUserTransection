import Foundation
import MessageKit


struct User{
    var username: String
    var email: String
    var uid: String
    var messages: [Message]

    
}

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind

}

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}
