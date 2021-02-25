//
//  ViewController.swift
//  ChatApp
//
//  Created by Saber on 25/02/2021.
//

import UIKit
import Firebase

class SignInSignUpViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "formCell", for: indexPath) as! FormCell
        if indexPath.row == 0 {
            //sign in cell
            
            cell.usernameContainer.isHidden = true
            cell.sliderButton.setTitle("👉🏻 Signup", for: .normal)
            cell.actionButton.setTitle("Signin", for: .normal)
            cell.sliderButton.addTarget(self, action: #selector(slideToSignIn(_:)), for: .touchUpInside)
            cell.actionButton.addTarget(self, action: #selector(signInTapped(_:)), for: .touchUpInside)
            
        }else if indexPath.row == 1{
            // sign up cell
            
            cell.usernameContainer.isHidden = false
            cell.sliderButton.setTitle("👈🏻 signIn", for: .normal)
            cell.actionButton.setTitle("Signup", for: .normal)
            cell.sliderButton.addTarget(self, action: #selector(slideToSignUp(_:)), for: .touchUpInside)
            cell.actionButton.addTarget(self, action: #selector(signUpTapped(_:)), for: .touchUpInside)


        }
        
        return cell
    }
    
    @objc func slideToSignIn(_ sender: UIButton){
        collectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .centeredHorizontally, animated: true)
        
    }
    
    @objc func slideToSignUp(_ sender: UIButton){
        collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: true)

    }
    
    @objc func signUpTapped(_ sender: UIButton){
        let cell = self.collectionView.cellForItem(at: IndexPath(row: 1, section: 0)) as! FormCell
        
        guard let email = cell.emailTextField.text, let password = cell.passwordTextField.text, let username = cell.usernameTextField.text else {
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if  error == nil {
                guard let userId = result?.user.uid else {
                    return
                }
                let refrence = Database.database().reference()
                let user = refrence.child("users").child(userId)
                let dataDict: [String: Any] = ["username": username]
                user.setValue(dataDict)
                
            }
        }
        
        
    }
    
    @objc func signInTapped(_ sender: UIButton){
        
        let cell = self.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as! FormCell
        
        guard let email = cell.emailTextField.text, let password = cell.passwordTextField.text else {
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error == nil{
                self.dismiss(animated: true, completion: nil)
            }else{
                self.showAlert(message: "Wrong something")
            }
        }
        
        
    }
    
    func showAlert(message: String){
        
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return collectionView.frame.size
    }
    }
    

    




