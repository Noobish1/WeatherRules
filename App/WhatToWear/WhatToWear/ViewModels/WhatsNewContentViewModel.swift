import Foundation
import WhatToWearCommonCore
import WhatToWearCore
import WhatToWearModels

internal struct WhatsNewContentViewModel {
    // MARK: properties
    private let updates: NonEmptyArray<WhatsNewUpdateViewModel>

    // MARK: computed properties
    internal var numberOfUpdates: Int {
        return updates.count
    }
    
    // MARK: init
    internal init() {
        self.updates = WhatsNewVersion.nonEmptyCases
            .map(WhatsNewUpdateViewModel.init)
            .sorted(by: { $0.version > $1.version })
    }

    // Need this init for the unit tests
    internal init(updates: NonEmptyArray<WhatsNewUpdateViewModel>) {
        self.updates = updates
    }
    
    // MARK: section counts
    internal func numberOfUpdateSections(forUpdate update: Int) -> Int {
        return updates[update].segments.count
    }
    
    // MARK: section titles
    internal func sectionHeaderTitle(forSection section: Int) -> String {
        let updateSection = updates[section]

        return "\(Bundle.main.name) \(updateSection.version.shortStringRepresentation)"
    }
    
    // MARK: retrieving update sections
    internal func updateSection(at indexPath: IndexPath) -> WhatsNewSegmentViewModel {
        return updates[indexPath.section].segments[indexPath.row]
    }
    
    // MARK: checking for updates
    internal func hasUpdate(matching version: OperatingSystemVersion) -> Bool {
        return updates.any { $0.version == version }
    }
}
