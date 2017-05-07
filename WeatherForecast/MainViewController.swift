//
//  MainViewController.swift
//  WeatherForecast
//
//  Created by Quang Nghia on 5/7/17.
//  Copyright © 2017 Quang Nghia. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbTemperature: UILabel!
    @IBOutlet weak var lbLocation: UILabel!
    @IBOutlet weak var imgWeather: UIImageView!
    @IBOutlet weak var lbCurrentWeather: UILabel!
    @IBOutlet weak var tbWeatherNextTenDay: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbWeatherNextTenDay.delegate = self
        tbWeatherNextTenDay.dataSource = self
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

