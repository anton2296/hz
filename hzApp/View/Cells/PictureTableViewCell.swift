//
//  PictureTableViewCell.swift
//  hzApp
//
//  Created by serg Kh on 20.07.2020.
//  Copyright © 2020 Anton. All rights reserved.
//

import UIKit

class PictureTableViewCell: UITableViewCell {
    @IBOutlet private weak var pictureTextLabel: UILabel!
    @IBOutlet private weak var pictureImageView: UIImageView!
    
    func configure(text: String, url: URL?) {
        pictureTextLabel.text = text
        guard let url = url else {
            return
        }
        pictureImageView.loadImage(url: url)
    }
}
