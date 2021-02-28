//
//  ChatCell.swift
//  ChatApp
//
//  Created by Saber on 28/02/2021.
//

import UIKit

enum MessageSource {
    case me
    case friend
}

class ChatCell: UITableViewCell {
    
    

    @IBOutlet weak var usernameLabl: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var chatStackView: UIStackView!
    @IBOutlet weak var messageTctContainer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageTctContainer.layer.cornerRadius = 8
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setMessageSource(messageSource: MessageSource) {
        switch messageSource {
        case .me:
            chatStackView.alignment = .trailing
            messageTctContainer.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            messageLabel.textColor = .black
        case .friend:
            chatStackView.alignment = .leading
            messageTctContainer.backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
            messageLabel.textColor = .white
        }
    }

}
