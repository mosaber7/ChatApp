//
//  ViewController.swift
//  ChatApp
//
//  Created by Saber on 25/02/2021.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "formCell", for: indexPath) as! FormCell
        if indexPath.row == 0 {
            
            cell.usernameContainer.isHidden = true
            cell.sliderButton.setTitle("👉🏻 Signup", for: .normal)
            cell.actionButton.setTitle("Signin", for: .normal)
            cell.sliderButton.addTarget(self, action: #selector(slideToSignIn(_:)), for: .touchUpInside)
            
        }else if indexPath.row == 1{
            cell.usernameContainer.isHidden = false
            cell.sliderButton.setTitle("👈🏻 signIn", for: .normal)
            cell.actionButton.setTitle("Signup", for: .normal)
            cell.sliderButton.addTarget(self, action: #selector(slideToSignUp(_:)), for: .touchUpInside)

        }
        
        return cell
    }
    
    @objc func slideToSignIn(_ sender: UIButton){
        collectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .centeredHorizontally, animated: true)
        
    }
    
    @objc func slideToSignUp(_ sender: UIButton){
        collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: true)

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
    

    




