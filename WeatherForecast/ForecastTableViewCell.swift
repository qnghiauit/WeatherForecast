//
//  ForecastTableViewCell.swift
//  WeatherForecast
//
//  Created by Quang Nghia on 5/9/17.
//  Copyright © 2017 Quang Nghia. All rights reserved.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {

    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lbDay: UILabel!
    @IBOutlet weak var lbWeatherType: UILabel!
    @IBOutlet weak var lbHighTemp: UILabel!
    @IBOutlet weak var lbLowTemp: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(forecast: Forecast) {
        imgIcon.image = UIImage(named: forecast.weatherType)
        lbDay.text = forecast.date
        lbWeatherType.text = forecast.weatherType
        lbLowTemp.text = forecast.lowTempFormatted
        lbHighTemp.text = forecast.highTempFormatted
    }

}
