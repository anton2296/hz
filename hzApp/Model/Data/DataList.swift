//
//  ModelData.swift
//  hzApp
//
//  Created by serg Kh on 20.07.2020.
//  Copyright © 2020 Anton. All rights reserved.
//

import Foundation



enum ElementTypes: String {
    case hz
    case picture
    case selector
}

struct DataCell: Decodable {
    let name: String
    let element: Any?
    
    enum CodingKeys: String, CodingKey {
        case name
        case element = "data"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        switch name {
        case ElementTypes.hz.rawValue:
            element = try container.decode(Hz.self, forKey: .element)
        case ElementTypes.picture.rawValue:
            element = try container.decode(Picture.self, forKey: .element)
        case ElementTypes.selector.rawValue:
            element = try container.decode(Selector.self, forKey: .element)
        default:
            print("Decoding error! class name \"\(name)\" not found")
            element = nil
        }
    }
}
