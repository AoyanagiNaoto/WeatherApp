//
//  City.swift
//  WeatherApp
//
//  Created by Aoyagi Naoto on 2018/08/12.
//  Copyright © 2018年 vertex. All rights reserved.
//

import Foundation
import SwiftyJSON

class City{
    
    let id:String
    let title:String
    
    init(city: JSON){
        id = city ["id"].stringValue
        title = city["title"].stringValue
        
        
    }
}
