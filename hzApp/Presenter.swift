//
//  Presenter.swift
//  hzApp
//
//  Created by serg Kh on 21.07.2020.
//  Copyright © 2020 Anton. All rights reserved.
//

import Foundation

final class Presenter {
    private lazy var model: Model = {
        Model(delegate: self)
    }()
    private weak var delegate: PresenterDelegate?
    
    func attachView(_ presenterDelegate: PresenterDelegate) {
        self.delegate = presenterDelegate
    }
    
    func detachView() {
        self.delegate = nil
    }
    
    func loadData() {
        model.loadModelData()
    }
    
    func idIsSelectedFromSelector(id: Int){
        delegate?.presenter(self, idIsSelectedFromSelector: id)
    }
    
    func didSelectRowAtName(name: String?){
        if let name = name {
            delegate?.presenter(self, didSelectRowAt: name)
        }
    }
}

extension Presenter: ModelDelegate{
    func modelDidUpdate(_ model: Model, sequence: [String], dataList: [DataCell]) {
        let data = sequence.map{ name in
            dataList.first{$0.name == name} ?? nil
        }
        DispatchQueue.main.async {
            self.delegate?.presenterDataDidUpdate(self, data: data)
        }
    }
    
    func model(_ model: Model, errorForLoadData error: Error) {
        DispatchQueue.main.async {
            self.delegate?.presenter(self, errorForLoadData: error)
        }
    }
}

protocol PresenterDelegate: AnyObject {
    func presenterDataDidUpdate(_ presenter:Presenter, data: [DataCell?])
    func presenter(_ presenter: Presenter, idIsSelectedFromSelector id: Int)
    func presenter(_ presenter: Presenter, didSelectRowAt name: String)
    func presenter(_ presenter: Presenter, errorForLoadData error: Error)
}
