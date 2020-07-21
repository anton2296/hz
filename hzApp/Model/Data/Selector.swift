//
//  Selector.swift
//  hzApp
//
//  Created by serg Kh on 20.07.2020.
//  Copyright © 2020 Anton. All rights reserved.
//

import Foundation

struct Selector: Decodable {
    let selectedId: Int
    let variants: [SelectorVariant]
}
