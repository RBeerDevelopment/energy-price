//
//  PriceGraphWidget.swift
//  PriceGraphWidget
//
//  Created by Robin Beer on 29.06.23.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> WidgetEntry {
        WidgetEntry(date: Date(), energyPrices: demoEnergyPrices)
    }

    func getSnapshot(in context: Context, completion: @escaping (WidgetEntry) -> ()) {
        let entry = WidgetEntry(date: Date(), energyPrices: demoEnergyPrices)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<WidgetEntry>) -> ()) {
        Task {
            let prices: [EnergyPriceEntry] = await fetchEnergyPrices()
            
            let nextUpdate = Calendar.current.date(byAdding: DateComponents(minute: 15), to: Date())
            
            let entry = WidgetEntry(date: Date(), energyPrices: prices)
            
            let timeline = Timeline(entries: [entry], policy: .after(nextUpdate!))
            completion(timeline)
        }
    }
}

struct WidgetEntry: TimelineEntry {
    var date: Date
    var energyPrices: [EnergyPriceEntry]
}

struct PriceGraphWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            Text("Energy Prices")
            PriceChart(data: entry.energyPrices, isWidget: true)
        }
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

@main
struct PriceGraphWidget: Widget {
            
    @Environment(\.widgetFamily) var family: WidgetFamily

    let kind: String = "beer.robin.energy-price-graph"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            PriceGraphWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Energy Price Graph")
        .description("Up to 48h price graph.")
        .supportedFamilies([.accessoryRectangular,])
    }
}

struct Widget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PriceGraphWidgetEntryView(entry: WidgetEntry(date: Date(), energyPrices: demoEnergyPrices))
                .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
                .previewDisplayName("SmallPrveiw")
        }
    }
}
