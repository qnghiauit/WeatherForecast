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
            downloadDataFromApiProvider()
        } else {
            locationManager.requestWhenInUseAuthorization()
            authorizeAndGetLocation()
        }
    }
    
    func downloadDataFromApiProvider() {
        let apiUrl = "https://api.darksky.net/forecast/640ff36e1eeb8e3bdd8b302ca353089e/\(lat!),\(long!)"
        let forecastUrl = URL(string: apiUrl)!
        print(forecastUrl)
        Alamofire.request(forecastUrl).responseJSON { respond in
            let result = respond.result
            if let myDict = result.value as? Dictionary<String,AnyObject> {
                if let timezone = myDict["timezone"] as? String {
                    self.currentWeather._cityName = timezone
                }
                if let currently = myDict["currently"] as? Dictionary<String,AnyObject> {
                    if let time = currently["time"] as? Double {
                        let unitConvertedDate = Date(timeIntervalSince1970: time)
                        self.currentWeather._date = unitConvertedDate.dayOfWeek()
                    }
                    if let icon = currently["icon"] as? String {
                        self.currentWeather._weatherType = icon
                    }
                    if let summary = currently["summary"] as? String {
                        self.currentWeather._summary = summary
                    }
                    if let temp = currently["temperature"] as? Double {
                        self.currentWeather._temp = temp
                    }
                }
                if let daily = myDict["daily"] as? Dictionary<String,AnyObject> {
                    if let data = daily["data"] as? [Dictionary<String,AnyObject>] {
                        for i in 1...7 {
                            var forecast = Forecast()
                            if let time = data[i]["time"] as? Double {
                                let unitConvertedDate = Date(timeIntervalSince1970: time)
                                forecast.date = unitConvertedDate.dayOfWeek()
                            }
                            if let icon = data[i]["icon"] as? String {
                                forecast.weatherType = icon
                            }
                            if let summary = data[i]["summary"] as? String {
                                forecast.summary = summary
                            }
                            if let highTemp = data[i]["temperatureMax"] as? Double {
                                forecast.highTemp = highTemp
                            }
                            if let lowTemp = data[i]["temperatureMin"] as? Double {
                                forecast.lowTemp = lowTemp
                            }
                            self.forecasts.append(forecast)
                        }
                    }
                }
            }
            self.lbDate.text = self.currentWeather.dateConverted
            self.lbLocation.text = self.currentWeather._cityName
            self.lbTemperature.text = "\(self.currentWeather.tempFormated)"
            self.lbDate.text = self.currentWeather._date
            self.imgWeather.image = UIImage(named: self.currentWeather._weatherType)
            self.lbCurrentWeather.text = self.currentWeather._summary
            
            self.tbWeatherNextTenDay.reloadData()
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
