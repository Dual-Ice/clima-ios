//
//  WeatherManager.swift
//  Clima
//
//  Created by  Maksim Stogniy on 06.03.2024.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
    let apiUrl = "https://api.openweathermap.org/data/2.5/weather?appid=8a9fdf6af25b82ddb627c537c80fa6dd&units=metric"
    
    func fetchWeather(cityName: String) {
        let urlString = "\(apiUrl)&q=\(cityName)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url, completionHandler: handle(data: response: error:))
            
            task.resume()
        }
    }
    
    func handle(data: Data?, response: URLResponse?, error: Error?) {
        if error != nil {
            print(error!)
            return
        }
        
        if let safeData = data {
            let dataString = String(data: safeData, encoding: .utf8)
            print(dataString!)
        }
    }
}
