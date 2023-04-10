//
//  SideMenuCell.swift
//  SwiftAssignment
//
//  Created by MA-31 on 29/03/23.
//

import UIKit

class SideMenuCell: UITableViewCell {

    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        // Icon
        self.iconImageView.tintColor = .white
        // Title
        self.titleLabel.textColor = .white

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
