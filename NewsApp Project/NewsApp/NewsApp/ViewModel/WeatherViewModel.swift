//
//  WeatherViewModel.swift
//  NewsApp
//
//  Created by Saipujith on 30/03/21.
//

import Foundation

struct Weather: Codable {
    var temp: Double?
    var humidity: Double?
    var feels_like: Double?
    var temp_min: Double?
    var temp_max: Double?
}

struct WeatherViewModel: Codable{
    let main: Weather
}

func decodeJSONData(JSONData: Data){
    do{
        let weatherData = try? JSONDecoder().decode(WeatherViewModel.self, from: JSONData)
        if let weatherData = weatherData{
            let weather = weatherData.main
            print(weather.temp!)
            print(weather.humidity!)
        }
    }
}
