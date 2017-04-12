//
//  BillTableViewCell.swift
//  MySampleApp
//
//  Created by Joseph Barbati on 4/12/17.
//
//

import UIKit

class BillTableViewCell: UITableViewCell {
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
