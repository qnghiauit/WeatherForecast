//
//  MainViewController.swift
//  WeatherForecast
//
//  Created by Quang Nghia on 5/7/17.
//  Copyright © 2017 Quang Nghia. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbTemperature: UILabel!
    @IBOutlet weak var lbLocation: UILabel!
    @IBOutlet weak var imgWeather: UIImageView!
    @IBOutlet weak var lbCurrentWeather: UILabel!
    @IBOutlet weak var tbWeatherNextTenDay: UITableView!
    
    var lat: Double!
    var long: Double!
    var currentWeather : CurrentWeather!
    var forecasts : [Forecast]!
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        
        currentWeather = CurrentWeather()
        forecasts = [Forecast]()
        
        authorizeAndGetLocation()

        tbWeatherNextTenDay.delegate = self
        tbWeatherNextTenDay.dataSource = self
    }
    
    func authorizeAndGetLocation() {
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = locationManager.location
            lat = currentLocation.coordinate.latitude
            long = currentLocation.coordinate.longitude
            downloadWeatherData()
            downloadForecastData()
        } else {
            locationManager.requestWhenInUseAuthorization()
            authorizeAndGetLocation()
        }
    }
    
    func downloadForecastData() {
        let apiUrl = "http://samples.openweathermap.org/data/2.5/forecast/daily?lat=\(lat!)&lon=\(long!)&cnt=10&appid=b1b15e88fa797225412429c1c50c122a1"
        let forecastUrl = URL(string: apiUrl)!
        print(forecastUrl)
        Alamofire.request(forecastUrl).responseJSON { respond in
            let result = respond.result
            if let myDict = result.value as? Dictionary<String,AnyObject> {
                if let forecastArray = myDict["list"] as? [Dictionary<String,AnyObject>] {
                    for i in 0...9 {
                        let forecast = Forecast()
                        if let day = forecastArray[i]["temp"] as? Dictionary<String,AnyObject> {
                            if let min = day["min"] as? Double {
                                forecast.lowTemp = round(min - 273.15)
                            }
                            if let max = day["max"] as? Double {
                                forecast.highTemp = round(max - 273.15)
                            }
                        }
                        if let dt = forecastArray[i]["dt"] as? Double {
                            let unitConvertedDate = Date(timeIntervalSince1970: dt)
                            forecast.date = unitConvertedDate.dayOfWeek()
                        }
                        if let weather = forecastArray[i]["weather"] as? [Dictionary<String,AnyObject>] {
                            if let weathertype = weather[0]["main"] as? String {
                                forecast.weatherType = weathertype
                            }
                        }
                        self.forecasts.append(forecast)
                        print(self.forecasts[i].toString())
                        
                    }
                }
            }
            self.tbWeatherNextTenDay.reloadData()
        }
    }
    
    func downloadWeatherData() {
        let apiUrl = "http://samples.openweathermap.org/data/2.5/weather?lat=\(lat!)&lon=\(long!)&appid=4efa6d7498432f279f0f6b43d8bcd8c7"
        let currentWeatherUrl = URL(string: apiUrl)!
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
        return forecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tbWeatherNextTenDay.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as? ForecastTableViewCell {
            let forecast = forecasts[indexPath.row]
            cell.setData(forecast: forecast)
            return cell
        }
        return tbWeatherNextTenDay.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath)
    }
}

extension Date {
    func dayOfWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
}
