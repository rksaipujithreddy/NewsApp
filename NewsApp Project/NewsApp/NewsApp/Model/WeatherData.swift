//
//  WeatherData.swift
//  NewsApp
//
//  Created by Saipujith on 30/03/21.
//

import Foundation

struct WeatherData: Decodable {
    let list: [List]
}
 
struct Main: Decodable {
    let temp: Float
    let temp_max: Float
    let temp_min: Float
    let feels_like: Float
    let humidity: Float
}
 
struct Weather2: Decodable {
    let main: String
    let description: String
    let icon: String
}
 
struct List: Decodable {
    let main: Main
    let weather: [Weather2]
}

func decodeJSONForecast(JSONData: Data){
    let response = try! JSONDecoder().decode(WeatherData.self, from: JSONData)
    
    for i in response.list {
        print("Temp : \(i.main.temp)")
        print("Temp Max : \(i.main.temp_max)")
        print("Temp Min : \(i.main.temp_min)")
        print("Feels Like : \(i.main.feels_like)")
        print("Humidity : \(i.main.humidity)")
        for j in i.weather {
            print("Main : \(j.main)")
            print("Description : \(j.description)")
            print("Icon : \(j.icon)")
        }
    }
}

