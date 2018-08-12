//
//  Pref.swift
//  WeatherApp
//
//  Created by Aoyagi Naoto on 2018/08/12.
//  Copyright © 2018年 vertex. All rights reserved.
//

import Foundation
import SwiftyJSON

class Pref{
    
    let title:String
    let cities:[City]
    
    init(pref: JSON){
        title = pref["title"].stringValue
        cities = pref["city"].arrayValue.map({item in
            return City(city: item)
            
        })
    }
}
