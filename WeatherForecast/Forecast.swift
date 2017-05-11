//
//  Forecast.swift
//  WeatherForecast
//
//  Created by Quang Nghia on 5/9/17.
//  Copyright © 2017 Quang Nghia. All rights reserved.
//

import Foundation
import Alamofire

class Forecast {
    var date : String!
    var weatherType : String!
    var highTemp : Double!
    var lowTemp : Double!
    var summary : String!
    
    var highTempFormatted : String {
        if highTemp == nil {
            return "NaN"
        }
        return "\(Int(highTemp))°C"
    }
    var lowTempFormatted : String {
        if lowTemp == nil {
            return "NaN"
        }
        return "\(Int(lowTemp))°C"
    }
    
    func toString() -> String {
        return "\(date!) \(weatherType!) \(highTempFormatted) \(lowTempFormatted)"
    }
}
