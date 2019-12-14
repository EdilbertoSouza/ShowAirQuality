//
//  City.swift
//  ShowAirQuality
//
//  Created by Edilberto on 07/12/19.
//  Copyright © 2019 Edilberto. All rights reserved.
//

import UIKit

class City {
    var name: String = ""
    var state: String = ""
    var country: String = ""
    var aqius: Int = 0
    var tp: Int = 0
    var hu: Int = 0
    var pr: Int = 0
        
    convenience init(_ name: String, _ state: String, _ country: String, _ aqius: Int, _ tp: Int, _ hu: Int) {
        self.init()
        self.name = name
        self.state = state
        self.country = country
        self.aqius = aqius
        self.tp = tp
        self.hu = hu
        self.pr = pr
    }
}
