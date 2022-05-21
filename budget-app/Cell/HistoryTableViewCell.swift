//
//  HistoryTableViewCell.swift
//  budget-app
//
//  Created by gumball on 5/10/22.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var historyImage: UIImageView!
    @IBOutlet weak var historyExpense: UILabel!
    @IBOutlet weak var historyAccount: UILabel!
    @IBOutlet weak var historyMoney: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
