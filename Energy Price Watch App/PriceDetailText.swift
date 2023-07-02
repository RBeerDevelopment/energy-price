//
//  CurrentPriceText.swift
//  Energy Price Watch App
//
//  Created by Robin Beer on 29.06.23.
//

import SwiftUI

struct PriceDetailText: View {
    var priceEntry: EnergyPriceEntry?
    
    
    var body: some View {
        if let priceEntry = priceEntry {
            return AnyView(HStack(alignment: .center, spacing: 12) {
                Text(priceEntry.start, style: .time)
                Text("\(priceEntry.marketprice, specifier: "%.2f") ct")
                
            })
        } else {
            return AnyView(Text(""))
        }
    }
}

#Preview {
    PriceDetailText(priceEntry: demoEnergyPrices.first!)
}
