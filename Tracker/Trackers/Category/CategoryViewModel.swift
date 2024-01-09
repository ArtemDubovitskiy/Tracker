//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Artem Dubovitsky on 29.12.2023.
//
import Foundation

final class CategoryViewModel {
    private var trackerCategoryStore = TrackerCategoryStore()
    private (set) var categories: [TrackerCategory] = []
    
    @Observable
    private (set) var selectedCategory: TrackerCategory?
    
    init() {
        trackerCategoryStore.delegate = self
        self.categories = trackerCategoryStore.trackerCategories
    }
    
    func addCategory(_ name: String) {
        do {
            try self.trackerCategoryStore.addCategory(TrackerCategory(title: name, trackers: []))
        } catch {
            print("Error add category: \(error.localizedDescription)")
        }
    }
    
    func addNewTrackerToCategory(to title: String?, tracker: Tracker) {
        do {
            try self.trackerCategoryStore.addNewTrackerToCategory(to: title, tracker: tracker)
        } catch {
            print("Error add new tracker to category: \(error.localizedDescription)")
        }
    }
    
    func selectCategory(_ index: Int) {
        self.selectedCategory = self.categories[index]
    }
    
    func checkingSavedCategory(_ title: String) -> Bool {
        return categories.contains(where: { $0.title == title })
    }
}
// MARK: - TrackerCategoryStoreDelegate
extension CategoryViewModel: TrackerCategoryStoreDelegate {
    func categoryStore() {
        self.categories = trackerCategoryStore.trackerCategories
    }
}
