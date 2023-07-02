//
//  PriceFetch.swift
//  Energy Price
//
//  Created by Robin Beer on 29.06.23.
//

import Foundation

func fetchEnergyPrices() async -> [EnergyPriceEntry] {
    
    let (start, end) = getTimeBoundsInMsFromEpoch();
    guard let url = URL(string: "https://api.awattar.de/v1/marketdata?start=\(start)&end=\(end)") else {
        print("Invalid URL")
        return []
    }
    
    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .millisecondsSince1970
        
        if let decodedResponse = try? decoder.decode(EnergyPriceResponse.self, from: data) {
            return decodedResponse.data
        }
    } catch {
        return []
    }
    
    return []
}

let DAY_IN_MS = 24*3600*1000

func getTimeBoundsInMsFromEpoch() -> (Int64, Int64) {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(secondsFromGMT: 0)!
    let startOfDate = calendar.startOfDay(for: Date())
    let beginInMs = startOfDate.timeIntervalSince1970 * 1000
    
    let endInMs = beginInMs + Double(DAY_IN_MS)
    
    return (Int64(beginInMs), Int64(endInMs))
}

func isTimelineEntryNow(entry: EnergyPriceEntry) -> Bool {
    let now = Date()
    
    return entry.start < now && now < entry.end
}
