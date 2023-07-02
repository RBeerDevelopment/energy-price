//
//  TimelineData.swift
//  Energy Price Watch App
//
//  Created by Robin Beer on 27.06.23.
//

import Foundation
import WidgetKit

struct EnergyPriceResponse: Codable {
    let object: String
    let data: [EnergyPriceEntry]
    let url: String
}

struct EnergyPriceEntry: Codable, Identifiable {
    
    enum CodingKeys: String, CodingKey {
        case start = "start_timestamp"
        case end = "end_timestamp"
        case marketprice
    }

    var id: Date {
        start
    }
    
    let start, end: Date
    let marketprice: Double

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.start = try container.decode(Date.self, forKey: .start)
    self.end = try container.decode(Date.self, forKey: .end)
    // devide by 10 to get from EUR/MWh to ct/kWh
    self.marketprice = try container.decode(Double.self, forKey: .marketprice)/10
  }
    
  init(start: Date, end: Date, marketprice: Double) {
    self.start = start
    self.end = end
    self.marketprice = marketprice
  }
}


func medianPrice(entries: [EnergyPriceEntry]) -> Double {
    return entries.map { $0.marketprice }.sorted(by: <)[entries.count / 2]
}


let demoEnergyPrices: [EnergyPriceEntry] = [
    EnergyPriceEntry(start: Date(timeIntervalSince1970: 1687996800), end: Date(timeIntervalSince1970: 1688000400), marketprice: 10.72),
    EnergyPriceEntry(start: Date(timeIntervalSince1970: 1688004000), end: Date(timeIntervalSince1970: 1688007600), marketprice: 9.92),
    EnergyPriceEntry(start: Date(timeIntervalSince1970: 1688007600), end: Date(timeIntervalSince1970: 1688011200), marketprice: 10.52),
    EnergyPriceEntry(start: Date(timeIntervalSince1970: 1688011200), end: Date(timeIntervalSince1970: 1688014800), marketprice: 12.81)
]
