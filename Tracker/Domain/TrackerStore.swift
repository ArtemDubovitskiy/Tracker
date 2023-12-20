//
//  TrackerStore.swift
//  Tracker
//
//  Created by Artem Dubovitsky on 27.11.2023.
//
import UIKit
import CoreData

enum TrackerStoreError: Error {
    case decodingErrorInvalidId
    case decodingErrorInvalidTitle
    case decodingErrorInvalidColor
    case decodingErrorInvalidEmoji
    case decodingErrorInvalidSchedule
    case decodingErrorInvalid
}

protocol TrackerStoreDelegate: AnyObject {
    func store()
}

final class TrackerStore: NSObject {
    // MARK: - Public Properties
    weak var delegate: TrackerStoreDelegate?
    var trackers: [Tracker] {
        guard
            let objects = self.fetchedResultsController.fetchedObjects,
            let trackers = try? objects.map({ try self.tracker(from: $0) })
        else { return [] }
        return trackers
    }
    // MARK: - Private Properties
    private let colorMarshalling = UIColorMarshalling()
    private let daysValueTransformer = DaysValueTransformer()
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>!
    // MARK: - Initializers
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        try! self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
        
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCoreData.id, ascending: true)
        ]
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        self.fetchedResultsController = controller
        try controller.performFetch()
    }
    
    // MARK: - Public Methods
    func createTracker(_ tracker: Tracker) throws -> TrackerCoreData {
        let trackerCoreData = TrackerCoreData(context: context)
        updateExistingTracker(trackerCoreData, with: tracker)
        try context.save()
        return trackerCoreData
    }
    
    func updateExistingTracker(_ trackerCoreData: TrackerCoreData, 
                               with tracker: Tracker
    ) {
        trackerCoreData.id = tracker.id
        trackerCoreData.title = tracker.title
        trackerCoreData.color = colorMarshalling.hexString(from: tracker.color)
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.schedule = tracker.schedule as NSObject
    }
    // MARK: - Private Methods
    private func tracker(from trackersCoreData: TrackerCoreData) throws -> Tracker {
        guard let id = trackersCoreData.id else {
            throw TrackerStoreError.decodingErrorInvalidId
        }
        
        guard let title = trackersCoreData.title else {
            throw TrackerStoreError.decodingErrorInvalidTitle
        }
        
        guard let color = trackersCoreData.color else {
            throw TrackerStoreError.decodingErrorInvalidColor
        }
        
        guard let emoji = trackersCoreData.emoji else {
            throw TrackerStoreError.decodingErrorInvalidEmoji
        }
        
        guard let schedule = trackersCoreData.schedule else {
            throw TrackerStoreError.decodingErrorInvalidSchedule
        }
        
        return Tracker(
            id: id,
            title: title,
            color: colorMarshalling.color(from: color),
            emoji: emoji,
            schedule: schedule as! [WeekDay])
    }
}
// MARK: - NSFetchedResultsControllerDelegate
extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>
    ) {
        delegate?.store()
    }
}
