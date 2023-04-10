//
//  myTableViewCell.swift
//  SwiftAssignment
//
//  Created by MA-31 on 23/03/23.
//

import UIKit

class myTableViewCell: UITableViewCell {

    var btnEditClicked: (() -> Void)? = nil
    var btnDeleteClicked: (() -> Void)? = nil
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var firstNameCell: UILabel!
    @IBOutlet weak var lastNameCell: UILabel!
    @IBOutlet weak var userButtonEdit: UIButton!
    @IBOutlet weak var userButtonDelete: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func userButtonEditAction(_ sender: Any) {
        btnEditClicked?()
    }
    @IBAction func userButtonDeleteAction(_ sender: Any) {
        btnDeleteClicked?()
    }
    
}
