//
//  SelectorTableViewCell.swift
//  hzApp
//
//  Created by serg Kh on 20.07.2020.
//  Copyright © 2020 Anton. All rights reserved.
//

import UIKit

class SelectorTableViewCell: UITableViewCell {
    @IBOutlet private weak var pickerView: UIPickerView!
    private var pickerViewData: [String] = []
    weak var delegate: SelectorTableViewCellDelegate?
    
    override func awakeFromNib() {
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
    }
    
    func configure(delegate: SelectorTableViewCellDelegate,
                   id: Int, data: [String]) {
        pickerViewData = data
        self.delegate = delegate
        pickerView.reloadAllComponents()
        pickerView.selectRow(id, inComponent: 0, animated: true)
    }
}

extension SelectorTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerViewData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.selectorTableViewCell(self, idIsSelected: row)
    }
}

protocol SelectorTableViewCellDelegate: AnyObject {
    func selectorTableViewCell(_ selectorTableViewCell: SelectorTableViewCell, idIsSelected id: Int)
}
