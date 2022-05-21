//
//  IncomeCollectionViewCell.swift
//  budget-app
//
//  Created by gumball on 5/9/22.
//

import UIKit

class IncomeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var incomeImage: UIImageView!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var incomeMoney: UILabel!
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
           
        setNeedsLayout()
        layoutIfNeeded()
           
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
           
        var frame = layoutAttributes.frame
        frame.size.height = ceil(size.height)
        layoutAttributes.frame = frame
           
        return layoutAttributes
    }
}
