//
//  Account.swift
//  bbuddy
//
//  Created by Jackson Zhang on 14/02/2017.
//  Copyright © 2017 odd-e. All rights reserved.
//

import Foundation

class Account {
    private var api:Api
    var name = ""
    var balance = 0
    
    init(api: Api){
        self.api = api
    }
    
    func save(_ action: @escaping () -> Void){
        api.addAccount(DTO.Account(id: 0, name: name, balance: balance), to: action)
    }
}
