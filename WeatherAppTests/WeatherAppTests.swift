//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by Камиль Сулейманов on 13.10.2021.
//

import XCTest
@testable import WeatherApp

class WeatherAppTests: XCTestCase {
    var vc: ViewController!
    
    override func setUpWithError() throws {
        vc = ViewController()
    }
    
    override func tearDownWithError() throws {
        vc = nil
    }
    
    func testGettingData() throws {
        var weather: JSONWeather? = nil
        
        let expectation = XCTestExpectation(description: "Parse JSON from API")
        
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=42.9764&lon=47.5024&appid=16cf9696c382b9ef7eb3981ea30ed2df")!
    
        let dataTask = URLSession.shared.dataTask(with: url) { (data, _, _) in
 
            XCTAssertNotNil(data, "No data was downloaded.")
            
            let decoder = JSONDecoder()
            do {
                let APIWeather = try decoder.decode(JSONWeather.self, from: data!)
                weather = APIWeather
              
            } catch {
                print("Error parsing JSON")
            }
            
            expectation.fulfill()
            
        }
        dataTask.resume()
        wait(for: [expectation], timeout: 2)
        
        
        XCTAssertNotNil(weather, "Fail to parse JSON")
        
    }
}
