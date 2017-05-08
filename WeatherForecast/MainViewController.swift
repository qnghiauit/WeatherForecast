//
//  MainViewController.swift
//  WeatherForecast
//
//  Created by Quang Nghia on 5/7/17.
//  Copyright © 2017 Quang Nghia. All rights reserved.
//

import UIKit
import Alamofire

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbTemperature: UILabel!
    @IBOutlet weak var lbLocation: UILabel!
    @IBOutlet weak var imgWeather: UIImageView!
    @IBOutlet weak var lbCurrentWeather: UILabel!
    @IBOutlet weak var tbWeatherNextTenDay: UITableView!
    
    var lat: Double!
    var long: Double!
    var currentWeather : CurrentWeather!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentWeather = CurrentWeather()
        lat = 35
        long = 139
        downloadWeatherData()
        
        tbWeatherNextTenDay.delegate = self
        tbWeatherNextTenDay.dataSource = self
    }
    
    func downloadWeatherData() {
        let weatherUrl = "http://samples.openweathermap.org/data/2.5/weather?lat=\(lat!)&lon=\(long!)&appid=4efa6d7498432f279f0f6b43d8bcd8c7"
        let currentWeatherUrl = URL(string: weatherUrl)!
        print(currentWeatherUrl)
        Alamofire.request(currentWeatherUrl).responseJSON { respone in
            let result = respone.result
            if let myDict = result.value as? Dictionary<String,AnyObject> {
                if let cityname = myDict["name"] as? String {
                    self.currentWeather._cityName = cityname.capitalized
                }
                if let weathertype = myDict["weather"] as? [Dictionary<String,AnyObject>] {
                    if let type = weathertype[0]["main"] as? String {
                        self.currentWeather._weatherType = type
                    }
                }
                if let main = myDict["main"] as? Dictionary<String,AnyObject> {
                    if let temp = main["temp"] as? Double {
                        self.currentWeather._temp = round(temp - 273.15)
                    }
                }
            }
            self.lbDate.text = self.currentWeather.dateConverted
            self.lbLocation.text = self.currentWeather._cityName
            self.lbTemperature.text = "\(self.currentWeather.tempFormated)"
            self.lbDate.text = self.currentWeather._date
            self.imgWeather.image = UIImage(named: self.currentWeather._weatherType)
    }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbWeatherNextTenDay.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath)
        return cell
    }
}

