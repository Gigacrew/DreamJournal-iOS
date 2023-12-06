import WidgetKit
import SwiftUI
import Intents


struct Provider: IntentTimelineProvider {
    var dreamsArray = ["Host dinner parties, Or start/join a supper club.","Steward a Little Free Library.","Take art classes.","Go away for a girls’ weekend.","Get really familiar with our local parks system.","I want to know the trails like the back of my hand."]


    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), str: "Step 1", configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), str: "Step 2", configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for timeOffset in 0 ..< dreamsArray.count {
            let entryDate = Calendar.current.date(byAdding: .second, value: 2 * timeOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, str: dreamsArray[timeOffset], configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let str: String
    let configuration: ConfigurationIntent

}

struct DreamJournal_WidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Text("DREAM OF THE DAY")
            .font(.headline)// You can adjust the font style as needed
            .padding(.top, 5)

        VStack {
            Text(entry.str)
                .font(.system(size: 15))
                .padding(.bottom, 2) // Add bottom padding for separation
                .multilineTextAlignment(.center) // Set multiline text alignment
                .lineLimit(2) // Allow unlimited lines for the text

            Image("Dream_journal_logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 80)
        }
        .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)) // Adjust overall padding
    }
        
    
    
    
}

struct DreamJournal_Widget: Widget {
    let kind: String = "DreamJournal_Widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            DreamJournal_WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Dream Journal Widget")
        .description("This is an example widget.")
    }
}

struct DreamJournal_Widget_Previews: PreviewProvider {
    static var previews: some View {
        DreamJournal_WidgetEntryView(entry: SimpleEntry(date: Date(), str: "Preview Text", configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
