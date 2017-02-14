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
    var id = 0
    var name = ""
    var balance = 0
    
    init(api: Api){
        self.api = api
    }
    
    func save(_ action: @escaping () -> Void){
        let accountToUpdate = DTO.Account(id: id, name: name, balance: balance)
        id == 0 ? api.addAccount(accountToUpdate, to: action) : api.updateAccount(accountToUpdate, to: action)
    }
}
