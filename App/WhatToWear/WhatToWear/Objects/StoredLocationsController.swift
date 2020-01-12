import ErrorRecorder
import Foundation
import WhatToWearCommonCore
import WhatToWearCore
import WhatToWearCoreComponents
import WhatToWearModels

internal final class StoredLocationsController {
    // MARK: properties
    private var storedLocations: StoredLocations
    
    // MARK: computed properties
    internal var defaultLocation: ValidLocation {
        return storedLocations.defaultLocation
    }
    
    internal var locations: NonEmptyArray<ValidLocation> {
        return storedLocations.locations
    }
    
    // MARK: init
    internal init(storedLocations: StoredLocations) {
        self.storedLocations = storedLocations
    }
    
    // MARK: adding
    internal func add(location: ValidLocation) {
        let newLocations = storedLocations.adding(location: location)
        
        self.storedLocations = newLocations
        
        LocationController.shared.save(newLocations)
    }
    
    // MARK: changing default location
    internal func switchDefaultLocation(to location: ValidLocation) {
        let newLocations = storedLocations.with(\.defaultLocation, value: location)
        
        self.storedLocations = newLocations
        
        // We delay this by a runloop because it can make UI look less responsive
        DispatchQueue.main.async {
            LocationController.shared.save(newLocations)
        }
        
        Analytics.record(event: .locationSelected)
    }
    
    // MARK: removing locations
    internal func removeLocation(at index: Int) {
        let oldLocations = storedLocations.locations
        let newLocations = oldLocations.toArray().byRemoving(at: [index])
        
        guard let nonEmptyLocations = NonEmptyArray(array: newLocations) else {
            fatalError("Removing the last location in StoredLocations")
        }
        
        let newStoredLocations = StoredLocations(
            locations: nonEmptyLocations, defaultLocation: storedLocations.defaultLocation
        )
        
        self.storedLocations = newStoredLocations
        
        LocationController.shared.save(newStoredLocations)
    }
}
