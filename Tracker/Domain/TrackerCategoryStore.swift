//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Artem Dubovitsky on 27.11.2023.
//
import UIKit
import CoreData

enum TrackerCategoryStoreError: Error {
    case decodingErrorInvalidTitle
    case decodingErrorInvalidTracker
    case decodingErrorInvalidFetchTitle
    case decodingErrorInvalid
}

protocol TrackerCategoryStoreDelegate: AnyObject {
    func categoryStore()
}

final class TrackerCategoryStore: NSObject {
    // MARK: - Public Properties
    weak var delegate: TrackerCategoryStoreDelegate?
    var trackerCategories: [TrackerCategory] {
        guard
            let objects = self.fetchedResultsController.fetchedObjects,
            let trackers = try? objects.map({ try self.trackerCategory(from: $0) })
        else { return [] }
        return trackers
    }
    
    // MARK: - Private Properties
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>!
    private let trackerStore = TrackerStore()
    // MARK: - Initializers
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        try! self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
        
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCategoryCoreData.title, ascending: true)
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
    func addCategory(_ category: TrackerCategory) throws {
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        trackerCategoryCoreData.title = category.title
        trackerCategoryCoreData.trackers = NSSet(array: [])
        try context.save()
    }
    
    func addNewTrackerToCategory(to title: String?, tracker: Tracker) throws {
        let trackerCoreData = try trackerStore.createTracker(tracker)
        
        if let category = try? fetchTrackerCategory(with: title) {
            guard let trackers = category.trackers else { return }
            guard var newTrackerCoreData = trackers.allObjects as? [TrackerCoreData] else { return }
            newTrackerCoreData.append(trackerCoreData)
            category.trackers = NSSet(array: newTrackerCoreData)
        } else {
            let newCategory = TrackerCategoryCoreData(context: context)
            newCategory.title = title
            newCategory.trackers = NSSet(array: [trackerCoreData])
        }
        try context.save()
    }
    
    func fetchTrackerCategory(with title: String?) throws -> TrackerCategoryCoreData? {
        guard let title = title else {
            throw TrackerCategoryStoreError.decodingErrorInvalidFetchTitle
        }
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "title == %@",
            title as CVarArg)
        let result = try context.fetch(fetchRequest)
        return result.first
    }
    // MARK: - Private Methods
    private func trackerCategory(
        from trackersCategoryCoreData: TrackerCategoryCoreData
    ) throws -> TrackerCategory {
        guard let title = trackersCategoryCoreData.title else {
            throw TrackerCategoryStoreError.decodingErrorInvalidTitle
        }
        
        guard let trackers = trackersCategoryCoreData.trackers?.allObjects as? [TrackerCoreData] else {
            throw TrackerCategoryStoreError.decodingErrorInvalidTracker
        }
        
        return TrackerCategory(
            title: title,
            trackers: trackerStore.trackers.filter { trackers.map {$0.id}.contains($0.id)})
    }
}
// MARK: - NSFetchedResultsControllerDelegate
extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>
    ) {
        delegate?.categoryStore()
    }
}
