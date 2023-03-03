//
//  ViewController.swift
//  Weather
//
//  Created by Yasin Cetin on 28.02.2023.
//

import UIKit
import CoreLocation

class ViewController: UIViewController,UITextFieldDelegate{

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherSymbol: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        weatherManager.delegate = self
        searchTextField.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        }else{
            textField.placeholder = "type a city name"
            return false
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if let cityName = searchTextField.text{
            weatherManager.fetchWeather(cityName)
        }
        searchTextField.text = ""
    }

    @IBAction func searchButtonTapped(_ sender: UIButton) {
        searchTextField.endEditing(true)
        if let cityName = searchTextField.text{
            weatherManager.fetchWeather(cityName)
        }

    }
    @IBAction func locationButtonTapped(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
}


extension ViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.tempLabel.text = "\(weather.temperatureString)℃"
            self.weatherSymbol.image = UIImage(systemName: weather.conditionName)
            self.locationLabel.text = weather.cityName
            self .descriptionLabel.text = weather.description//********
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}


extension ViewController: CLLocationManagerDelegate {
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: latitude, longitude: longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
