//
//  ChatRoomViewController.swift
//  ChatApp
//
//  Created by Saber on 26/02/2021.
//

import UIKit
import Firebase

class ChatRoomViewController: UIViewController {
    
    @IBOutlet weak var messageTextField: UITextField!
    
    var room: Room?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        let user = refrence.child("users").child(userId)
        
        getUserNameByID(userId: userId) { (userName) in
            if let userName = userName, let roomID = self.room?.roomID{
                let dataDict : [String: Any] = ["username": userName, "text": message]
                
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
