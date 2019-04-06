//
//  Weather.swift
//  Assignment
//
//  Created by GadgetZone on 4/5/19.
//  Copyright © 2019 GadgetZone. All rights reserved.
//

import Foundation

struct Weather {
    var latitude: String
    var longitude: String
    var timeZone: String
}

struct CurrentlyWeather: Codable {
    var time: Float
    var summary: String
    var icon: String
    var temperature: String
    var pressure: String
    var humidity: String
    var windSpeed: String
    var windGust: String
    var windBearing: String
    var visibility: String
}

