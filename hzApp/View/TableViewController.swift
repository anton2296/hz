//
//  TableViewController.swift
//  hzApp
//
//  Created by serg Kh on 20.07.2020.
//  Copyright © 2020 Anton. All rights reserved.
//

import UIKit
import Toast_Swift

extension ElementTypes {
    var viewIdentifier: String {
        switch self {
            case .hz : return HzTableViewCell.resuseIdentifier
            case .picture : return PictureTableViewCell.resuseIdentifier
            case .selector : return SelectorTableViewCell.resuseIdentifier
        }
    }
}

final class TableViewController: UITableViewController {
    private let presenter = Presenter()
    private var data: [DataCell?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attachView(self)
        presenter.loadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataCell = data[indexPath.row]
        let viewIdentifier = (ElementTypes(rawValue: dataCell?.name ?? "")?.viewIdentifier ??
            ElementTypes.hz.viewIdentifier)
        let cell = tableView.dequeueReusableCell(
            withIdentifier: viewIdentifier,
            for: indexPath)
        switch viewIdentifier {
        case ElementTypes.hz.viewIdentifier:
            let cell = cell as! HzTableViewCell
            let element = dataCell?.element as! Hz
            cell.configure(text: element.text)
        case ElementTypes.picture.viewIdentifier:
            let cell = cell as! PictureTableViewCell
            let element = dataCell?.element as! Picture
            cell.configure(text: element.text, url: element.url)
        case ElementTypes.selector.viewIdentifier:
            let cell = cell as! SelectorTableViewCell
            let element = dataCell?.element as! Selector
            cell.configure(delegate: self, id: element.selectedId, data: element.variants.map{$0.text})
        default:
            print("View error")
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectRowAtName(name: data[indexPath.row]?.name)
    }
}

extension TableViewController: PresenterDelegate{
    func presenterDataDidUpdate(_ presenter: Presenter, data: [DataCell?]) {
        self.data = data
        tableView.reloadData()
    }
    
    func presenter(_ presenter: Presenter, didSelectRowAt name: String) {
        self.view.hideToast()
        self.view.makeToast("Selected cell for name: \(name)")
    }
    
    func presenter(_ presenter: Presenter, idIsSelectedFromSelector id: Int) {
        self.view.hideToast()
        self.view.makeToast("Selected item from selector with id: \(id)")
    }
    
    func presenter(_ presenter: Presenter, errorForLoadData error: Error) {
        self.view.hideToast()
        self.view.makeToast("Error: \(error.localizedDescription)")
    }
}

extension TableViewController: SelectorTableViewCellDelegate {
    func selectorTableViewCell(_ selectorTableViewCell: SelectorTableViewCell, idIsSelected id: Int) {
        presenter.idIsSelectedFromSelector(id: id)
    }
}
