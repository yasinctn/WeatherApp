//
//  WeatherManager.swift
//  Weather
//
//  Created by Yasin Cetin on 28.02.2023.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    var delegate: WeatherManagerDelegate?
    let apiKey = "" // Enter your openWeather API key here
    let url = "https://api.openweathermap.org/data/2.5/weather?&units=metric"
    
    func fetchWeather(_ cityName:String){
        let weatherURL = "\(url)&q=\(cityName)&appid=\(apiKey)"
        performRequest(weatherURL)
    }
    
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(url)&lat=\(latitude)&lon=\(longitude)"
        performRequest(urlString)
    }
    
    
    func performRequest(_ urlString:String){
        //Create a URL
        if let url = URL(string: urlString){
            
            //Create a URLSession
            let session = URLSession(configuration: .default)
            
            //Give the session a task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data{
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            //Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let description = decodedData.weather[0].description 
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp, description: description)
            return weather
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
