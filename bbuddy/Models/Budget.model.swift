//
//  Budget.model.swift
//  bbuddy
//
//  Created by Jackson Zhang on 16/03/2017.
//  Copyright © 2017 odd-e. All rights reserved.
//

import Foundation

class Budget{
    var month = ""
    var amount = 0
    
    func save(_ action: @escaping () -> Void){
        action()
    }
}
