//
//  UIImageView.swift
//  hzApp
//
//  Created by serg Kh on 20.07.2020.
//  Copyright © 2020 Anton. All rights reserved.
//

import Foundation

import UIKit

extension UIImageView{
    func loadImage(url: URL) {
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = try? Data(contentsOf: url), let image =   UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}
