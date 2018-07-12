//
//  ListTableViewCell.swift
//  NYTimes
//
//  Created by François-Julien Alcaraz on 10/07/2018.
//  Copyright © 2018 Mokriya. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell, ReusableCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var authorsLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!

    func configure(_ item: Article, at indexPath: IndexPath) {
        titleLabel.text = item.title
        authorsLabel.text = item.authors
        dateLabel.text = item.publishedAt
        
        accessibilityIdentifier = String(indexPath.row)
    }
}
