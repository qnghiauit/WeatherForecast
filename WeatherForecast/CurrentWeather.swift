//
//  CurrentWeather.swift
//  WeatherForecast
//
//  Created by Quang Nghia on 5/7/17.
//  Copyright © 2017 Quang Nghia. All rights reserved.
//

import UIKit
import Alamofire

class CurrentWeather {
    var _cityName : String!
    var _date: String!
    var _weatherType : String!
    var _temp : Double!
    var _summary : String!
    
    var dateConverted : String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        let currentDate = dateFormatter.string(from: Date())
        _date = "Today, \(currentDate)"
        return _date
    }
    
    var tempFormated : String {
        if _temp == nil {
            return "NaN"
        }
        return "\(Int(_temp))°C"
    }

}
