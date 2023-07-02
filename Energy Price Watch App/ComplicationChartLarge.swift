//
//  ComplicationChartLarge.swift
//  Energy Price Watch App
//
//  Created by Robin Beer on 29.06.23.
//

import SwiftUI
import ClockKit

struct ComplicationChartLarge: View {
    
    @State var timelineEntries: [TimelineEntry]
    var body: some View {
//        Text("Test")
//            .background(.red)
        PriceChart(data: timelineEntries)
    }
}


struct ComplicationController_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            
            CLKComplicationTemplateGraphicRectangularFullView(ComplicationChartLarge(timelineEntries: demoTimelineEntries)).previewContext()
            
            CLKComplicationTemplateGraphicExtraLargeCircularView(ComplicationChartLarge(timelineEntries: demoTimelineEntries)).previewContext(faceColor: .red)
        }
    }
}
