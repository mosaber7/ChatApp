//
//  ChatRoomViewController.swift
//  ChatApp
//
//  Created by Saber on 26/02/2021.
//

import UIKit
import Firebase

class ChatRoomViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var chatTableView: UITableView!
    var room: Room?
    var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatTableView.delegate = self
        chatTableView.dataSource = self
        title = room?.roomName
        observeMessages()
        
    }
    
    func observeMessages(){
        guard let roomID = room?.roomID else {
            return
        }
        
        let refrence = Database.database().reference()
        refrence.child("Room").child(roomID).child("messages").observe(.childAdded) { (snapshot) in
            if let dataDict = snapshot.value as? [String: Any]{
                guard let username = dataDict["username"] as? String, let messageText = dataDict["text"] as? String, let senderID = dataDict["senderID"] as? String else {
                    return
                }
                
                let message = Message.init(messageID: snapshot.key, messageText: messageText, username: username, senderID: senderID)
                self.messages.append(message)
                self.chatTableView.reloadData()
            }
        }
        
    }
    
    func getUserNameByID(userId: String, compeletion: @escaping (_ userName: String?)->Void){
        let refrence = Database.database().reference()
        let user = refrence.child("users").child(userId)
        
        user.child("username").observeSingleEvent(of: .value) { (snapshot) in
            if let userName = snapshot.value as? String{
                compeletion(userName)
            }else{
                compeletion(nil)
            }
            
            
        }
        
    }
    
    func sendMessage(message: String, compeletion: @escaping (_ isSuccesfull: Bool)-> ()){
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let refrence = Database.database().reference()
        
        getUserNameByID(userId: userId) { (userName) in
            if let userName = userName, let roomID = self.room?.roomID{
                let dataDict : [String: Any] = ["username": userName, "text": message, "senderID": userId]
                
                let room = refrence.child("Room").child(roomID)
                
                room.child("messages").childByAutoId().setValue(dataDict) { (error, _) in
                    if error == nil {
                        compeletion(true)
                        self.messageTextField.text = ""
                        print("message uploaded succesfully")
                    }
                    compeletion(false)
                }
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = chatTableView.dequeueReusableCell(withIdentifier: "ChatCell") as! ChatCell
        cell.usernameLabl.text = message.username
        cell.messageLabel.text = message.messageText
        if message.senderID == Auth.auth().currentUser!.uid{
            cell.setMessageSource(messageSource: .me)
        }else{
            cell.setMessageSource(messageSource: .friend)
        }
        
        return cell
    }
    
    
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        
        guard let message = messageTextField.text, message.isEmpty == false else {
            return
        }
        
        sendMessage(message: message){
            (isSuccesfull) in
            if isSuccesfull{
                print("yay")
            }
        }
        
    }
}
