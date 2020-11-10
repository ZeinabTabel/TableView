//
//  CustomCell.swift
//  TableView
//
//  Created by Zeinab on 10/28/20.
//  Copyright © 2020 Zeinab. All rights reserved.

import UIKit

protocol CustomCellDelegate: AnyObject {
    func showData(message: String?)
}

class CustomCell: UITableViewCell {
    
    var delegate: CustomCellDelegate?
    var comment: Comments?
    @IBOutlet weak var name: UILabel!
    @IBOutlet var number: UILabel!
    @IBOutlet var email: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func fill(comment: Comments) {
        name.text = comment.name
        number.text = String(comment.id)
        email.text = comment.email
        self.comment = comment
    }
    
    @IBAction func commentButton() {
        delegate?.showData(message: comment?.body)
    }
}
