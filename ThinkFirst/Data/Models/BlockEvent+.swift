import Foundation
import CoreData

extension BlockEvent {
    // Convenience initializer
    convenience init(context: NSManagedObjectContext, bundleID: String, skipped: Bool, timestamp: Date = Date()) {
        self.init(context: context)
        self.bundleID = bundleID
        self.skipped = skipped
        self.timestamp = timestamp
    }
    
    // Fetch request for all BlockEvents
    static func fetchAllRequest() -> NSFetchRequest<BlockEvent> {
        let request = NSFetchRequest<BlockEvent>(entityName: "BlockEvent")
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        return request
    }
    
    // Fetch request for blocks today
    static func fetchTodayRequest() -> NSFetchRequest<BlockEvent> {
        let request = NSFetchRequest<BlockEvent>(entityName: "BlockEvent")
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let predicate = NSPredicate(format: "timestamp >= %@", startOfDay as NSDate)
        request.predicate = predicate
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        return request
    }
    
    // Fetch request for total blocks (optionally filtered by skipped)
    static func fetchTotalRequest(skipped: Bool? = nil) -> NSFetchRequest<BlockEvent> {
        let request = NSFetchRequest<BlockEvent>(entityName: "BlockEvent")
        if let skipped = skipped {
            request.predicate = NSPredicate(format: "skipped == %@", NSNumber(value: skipped))
        }
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        return request
    }
}
