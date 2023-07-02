//
//  PriceChart.swift
//  Energy Price Watch App
//
//  Created by Robin Beer on 29.06.23.
//

import SwiftUI
import Charts

struct PriceChart: View {
    
    @State var scrollAmount = 0.0
    
    var data: [EnergyPriceEntry]
    var isWidget: Bool = false
    
    var body: some View {
        VStack {
            Chart {
                ForEach(data.indices, id: \.self) { index in
                    BarMark(x: .value("Time", data[index].start, unit: .hour), y: .value("Price", data[index].marketprice))
                        .foregroundStyle(index == Int(scrollAmount) ? .black : calculateBarColor(entry: data[index], allDayEntries: data))
                }
            }
            .chartXAxis(.hidden)
            .chartYAxis {
                AxisMarks(position: .automatic) {
                    AxisGridLine().foregroundStyle(.clear)
                    AxisValueLabel()
                }
            }
            renderPriceDetail()
        }
        .focusable(true)
        .digitalCrownRotation($scrollAmount, from: -1, through: Double(data.count), by: 1, sensitivity: .low, isContinuous: true, isHapticFeedbackEnabled: true)

    }
    
    func renderPriceDetail() -> some View {
        if(isWidget || scrollAmount < 0 || Int(scrollAmount) >= data.count) {
            return AnyView(EmptyView())
        }
        
        return AnyView(PriceDetailText(priceEntry: data[Int(scrollAmount)]))
    }
}



func calculateBarColor(entry: EnergyPriceEntry, allDayEntries: [EnergyPriceEntry]) -> Color {
    let color =
    if(isTimelineEntryNow(entry: entry)) { Color.white }
    else {
        entry.marketprice < medianPrice(entries: allDayEntries) ? Color.green : Color.red
    }
    
    return color
    
}

#Preview {
    PriceChart(data: demoEnergyPrices)
}
