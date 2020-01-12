import Foundation
import WhatToWearCore
import WhatToWearCoreComponents
import WhatToWearModels

internal final class LocationsViewModel {
    // MARK: properties
    private let locationsController: StoredLocationsController
    
    // MARK: init
    internal init(locationsController: StoredLocationsController) {
        self.locationsController = locationsController
    }
    
    // MARK: locations details
    internal func numberOfLocations() -> Int {
        return locationsController.locations.count
    }
    
    internal func location(at indexPath: IndexPath) -> ValidLocation {
        return locationsController.locations[indexPath.row]
    }
    
    internal func selectedLocationIndexPath() -> IndexPath {
        guard let rowIndex = locationsController.locations.firstIndex(of: locationsController.defaultLocation) else {
            fatalError("storedLocations.defaultLocation is not in storedLocations.locations")
        }
        
        return IndexPath(row: rowIndex, section: 0)
    }
    
    // MARK: editing
    internal func canEditLocation(at indexPath: IndexPath) -> Bool {
        let selectedIndexPath = selectedLocationIndexPath()

        return indexPath != selectedIndexPath
    }
    
    // MARK: selecting
    internal func selectLocation(at indexPath: IndexPath) {
        let selectedLocation = locationsController.locations[indexPath.row]
        
        locationsController.switchDefaultLocation(to: selectedLocation)
    }
    
    // MARK: adding
    internal func add(location: ValidLocation) {
        locationsController.add(location: location)
    }
    
    // MARK: removing
    internal func removeLocation(at indexPath: IndexPath) {
        locationsController.removeLocation(at: indexPath.row)
    }
}
