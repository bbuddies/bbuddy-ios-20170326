//
//  Budget.dto.swift
//  bbuddy
//
//  Created by Jackson Zhang on 16/03/2017.
//  Copyright © 2017 odd-e. All rights reserved.
//

import Foundation
import Argo
import Curry
import Runes

extension DTO{
    struct Budget {
        var id: Int = 0
        var month: String = ""
        var amount: Int = 0
    }
}
