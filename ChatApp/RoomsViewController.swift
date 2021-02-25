//
//  RoomsViewController.swift
//  ChatApp
//
//  Created by Saber on 25/02/2021.
//

import UIKit
import Firebase

class RoomsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var rooms = [Room]()
    
    @IBOutlet weak var roomNameTextField: UITextField!
    @IBOutlet weak var roomsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.roomsTableView.delegate = self
        self.roomsTableView.dataSource = self
        observeRooms()
    }
    
    @IBAction func logoutISTapped(_ sender: Any) {
        try! Auth.auth().signOut()
        self.presentFormVC()
        
    }
    
    /*  override func viewDidAppear(_ animated: Bool) {
     if Auth.auth().currentUser == nil{
     self.presentFormVC()
     }
     print(Auth.auth().currentUser)
     }*/
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Auth.auth().currentUser == nil{
            self.presentFormVC()
        }        
    }
    
    func presentFormVC(){
        let formViewController = self.storyboard?.instantiateViewController(identifier: "FormVC") as! SignInSignUpViewController
        formViewController.modalPresentationStyle = .fullScreen
        self.present(formViewController, animated: true, completion: nil)
        
    }
    func observeRooms(){
        let refrence = Database.database().reference()
        
        refrence.child("Room").observe(.childAdded) { (snapshot) in
            if let dataDict = snapshot.value as? [String: Any], let roomName = dataDict["roomName"] as? String{
                let room = Room(roomName: roomName)
                self.rooms.append(room)
                self.roomsTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let room = rooms[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell")!
        cell.textLabel?.text = room.roomName
        return cell
    }
    
    @IBAction func addRoomButtonTapped(_ sender: Any) {
        guard let roomName = roomNameTextField.text, roomName.isEmpty == false else {
            return
        }
        
        let refrence = Database.database().reference()
        
        let room = refrence.child("Room").childByAutoId()
        let dataDict :[String: Any] = ["roomName": roomName]
        room.setValue(dataDict) { (error,_)  in
            if error == nil{
                
                self.roomNameTextField.text = ""
                
            }
        }
        
    }
    
}
