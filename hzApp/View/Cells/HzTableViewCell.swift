//
//  HzTableViewCell.swift
//  hzApp
//
//  Created by serg Kh on 20.07.2020.
//  Copyright © 2020 Anton. All rights reserved.
//

import UIKit

final class HzTableViewCell: UITableViewCell {
    @IBOutlet private weak var hzTextLabel: UILabel!

    func configure(text: String) {
        hzTextLabel.text = text
    }
}
