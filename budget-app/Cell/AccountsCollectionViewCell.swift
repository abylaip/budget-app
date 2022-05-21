//
//  AccountsCollectionViewCell.swift
//  budget-app
//
//  Created by gumball on 5/10/22.
//

import UIKit

class AccountsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var accountsLabel: UILabel!
    @IBOutlet weak var accountsImage: UIImageView!
    @IBOutlet weak var accountsMoney: UILabel!
    
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
