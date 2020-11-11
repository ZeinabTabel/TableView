//
//  ViewDetails.swift
//  TableView
//
//  Created by Zeinab on 11/4/20.
//  Copyright © 2020 Zeinab. All rights reserved.
//

import UIKit

class ViewDetails: UIViewController {
    
    @IBOutlet weak var body: UILabel!
     var comment: Comments?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillDetails()
    }
    
    func fillDetails() {
        body.text = comment?.body
    }
}
