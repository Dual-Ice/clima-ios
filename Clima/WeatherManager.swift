//
//  WeatherManager.swift
//  Clima
//
//  Created by  Maksim Stogniy on 06.03.2024.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFail(with error: Error)
}

struct WeatherManager {
    var delegate: WeatherManagerDelegate?
    let apiUrl = "https://api.openweathermap.org/data/2.5/weather?appid=8a9fdf6af25b82ddb627c537c80fa6dd&units=metric"
    
    func fetchWeather(cityName: String) {
        let urlString = "\(apiUrl)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longtitude: CLLocationDegrees) {
        let urlString = "\(apiUrl)&lat=\(latitude)&lon=\(longtitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    self.delegate?.didFail(with: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            return WeatherModel(temperature: temp, conditionId: id, cityName: name)
        } catch {
            print(error)
            delegate?.didFail(with: error)
            return nil
        }
    }
    
    
    
}
