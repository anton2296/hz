//
//  Model.swift
//  hzApp
//
//  Created by serg Kh on 20.07.2020.
//  Copyright © 2020 Anton. All rights reserved.
//

import Foundation

enum NewsAPIConstants : String {
    case domain = "pryaniky.com"
}

/*
  Возможно реализация этого класса является нарушением принципа YAGNI,
 так как его функционал в принцыпе можно внести в Presenter, как предлагают
 тут: https://medium.com/@ronanwhite/mvp-design-pattern-in-ios-3b99a40fcabd
 Но по заданию было сказано про расширяемость, и если мы захотим прикрутить
 какую-нибудь базу данных или захотим хранить значение того-же селектора,
 он очень даже понадобиться, так как хранить и получать данные от сторонних
 источников обязанность модели.
 */
final class Model {
    private let api = APIService(domain: NewsAPIConstants.domain.rawValue)
    private weak var delegate: ModelDelegate?
    
    init(delegate: ModelDelegate){
        self.delegate = delegate
    }
    
    func loadModelData() {
        api.getData(apiEndpoint: APIEndpoint.sample) {
            [weak self] (result : Swift.Result<ModelData, Error>)  in
            guard let self = self else { return }
            switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self.delegate?.modelDidUpdate(
                            self,
                            sequence: data.view ,
                            dataList: data.data
                        )
                    }
                case .failure(let error):
                    self.delegate?.model(self, errorForLoadData: error)
            }
        }
    }
}

protocol ModelDelegate: AnyObject {
    func modelDidUpdate(_ model:Model, sequence: [String], dataList: [DataCell])
    func model(_ model: Model, errorForLoadData error: Error)
}
