import SwiftUI
import CoreData

struct StatsView: View {
    @FetchRequest(
        fetchRequest: BlockEvent.fetchTodayRequest(),
        animation: .default
    ) private var blocksToday: FetchedResults<BlockEvent>
    
    @FetchRequest(
        fetchRequest: BlockEvent.fetchAllRequest(),
        animation: .default
    ) private var allBlocks: FetchedResults<BlockEvent>
    
    var body: some View {
        VStack(spacing: 32) {
            Text("Stats")
                .font(.largeTitle.bold())
                .padding(.top)
            HStack(spacing: 40) {
                VStack {
                    Text("Blocks Today")
                        .font(.headline)
                    Text("\(blocksToday.count)")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundColor(.accentColor)
                        .accessibilityLabel("\(blocksToday.count) blocks today")
                }
                VStack {
                    Text("Total Blocks")
                        .font(.headline)
                    Text("\(allBlocks.count)")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundColor(.accentColor)
                        .accessibilityLabel("\(allBlocks.count) total blocks")
                }
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    StatsView()
}
