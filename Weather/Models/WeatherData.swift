//
//  WeatherData.swift
//  Weather
//
//  Created by Yasin Cetin on 28.02.2023.
//

import Foundation

struct WeatherData:Decodable {
    let name: String
    let main : Main
    let weather:[Weather]
}

struct Main: Decodable{
    let temp : Double
}

struct Weather: Decodable{
    let id : Int
    let description : String
}
