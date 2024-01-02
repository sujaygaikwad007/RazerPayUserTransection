import Foundation
import MessageKit

struct User {
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
    var amount: Double? 

    init(sender: SenderType, messageId: String, sentDate: Date, kind: MessageKind, amount: Double?) {
        self.sender = sender
        self.messageId = messageId
        self.sentDate = sentDate
        self.kind = kind
        self.amount = amount
    }
}

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}
