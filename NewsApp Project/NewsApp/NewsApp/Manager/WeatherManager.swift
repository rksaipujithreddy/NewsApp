//
//  WeatherManager.swift
//  NewsApp
//
//  Created by Saipujith on 30/03/21.
//

import Foundation


class WeatherManager {
    
    static let shared = WeatherManager()
    
    let apiKey = "bbcec094151bb9e28d243fb10c13b674"
   
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?q=Bengaluru&appid=bbcec094151bb9e28d243fb10c13b674&units=imperial"
    
    func pullJSONData(_ url: URL?,completionHandler: @escaping (_ succeeded: Bool, _ object: Weather?, _ error: Error?) -> Void) {
        
        guard let url = URL(string: weatherURL) else {
            print("Error : No Response")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error : \(error.localizedDescription)")
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("Error : HTTP Response Code Error")
                return
            }
            
            guard let data = data else {
                print("Error : No Response")
                return
            }
            
            do{
                let weatherData = try? JSONDecoder().decode(WeatherViewModel.self, from: data)
                if let weatherData = weatherData{
                    let weather = weatherData.main
                    print(weather.temp!)
                    print(weather.humidity!)
                    completionHandler(true, weather,nil)
                }
            }
        }
        task.resume()
    }
}
