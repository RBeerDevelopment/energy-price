//
//  ContentView.swift
//  Energy Price Watch App
//
//  Created by Robin Beer on 27.06.23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var energyPrices = [EnergyPriceEntry]()
    
    @Environment(\.scenePhase) var scenePhase
    
    
    var body: some View {
        VStack {
            energyPrices.isEmpty ? AnyView(ProgressView("Loading")) :
            AnyView(
                VStack {
                
                    Text("Current Prices")
                    .font(.headline)
                    .padding(.bottom, 4)
                
                    PriceDetailText(priceEntry: energyPrices.first(where: { isTimelineEntryNow(entry: $0)}))
                    PriceChart(data: energyPrices)

                }
            )
        }.onChange(of: scenePhase) {
            if(scenePhase != .active) {
                return
            }
            Task {
                await updatePrices()
            }
        }
    }
        
    
    func updatePrices() async {
        let response = await fetchEnergyPrices()
        if(response.isEmpty) {
            return
        }
        energyPrices = response
    }

}


#Preview {
    ContentView()
}
