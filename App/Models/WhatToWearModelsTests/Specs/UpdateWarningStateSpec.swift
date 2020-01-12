import Quick
import Nimble
import WhatToWearCore
@testable import WhatToWearModels
import WhatToWearModelsTesting

internal final class UpdateWarningStateSpec: QuickSpec {
    internal override func spec() {
        describe("UpdateWarningState") {
            describe("its init with globalSettings") {
                var state: UpdateWarningState!

                context("when the settings does not have a lastUpdateAvailable") {
                    beforeEach {                        
                        let settings = GlobalSettings.wtw.random()
                            .with(\.lastUpdateAvailable, value: nil)
                            .with(\.lastSeenUpdate, value: nil)

                        state = UpdateWarningState(globalSettings: settings)
                    }

                    it("should return hide") {
                        expect(state) == .hide
                    }
                }

                context("when the settings does have a lastUpdateAvailable") {
                    var bundle: Bundle!

                    beforeEach {
                        bundle = Bundle(for: type(of: self))
                    }

                    context("when the settings lastUpdateAvailable is not installable") {
                        beforeEach {
                            let formatter = DateFormatters.shared.appleReleaseDateFormatter(for: .current)

                            let update = LatestAppUpdate(
                                minimumOSVersionString: "0.0.0",
                                urlString: "https://www.example.com",
                                versionString: "99999.99999.9999",
                                currentVersionReleaseDate: ISO8601UTC(rawValue: formatter.string(from: .now)),
                                releaseNotes: String.wtw.random()
                            )

                            let settings = GlobalSettings.wtw.random()
                                .with(\GlobalSettings.lastUpdateAvailable, value: update)
                                .with(\.lastSeenUpdate, value: nil)

                            state = UpdateWarningState(globalSettings: settings, bundle: bundle)
                        }

                        it("should return hide") {
                            expect(state) == .hide
                        }
                    }

                    context("when the settings lastUpdateAvailable is installable") {
                        var lastUpdateAvailable: LatestAppUpdate!

                        context("when the settings does not have a lastSeenUpdate") {
                            beforeEach {
                                let formatter = DateFormatters.shared.appleReleaseDateFormatter(for: .current)

                                let releaseDate = Date.now.addingTimeInterval(-48.hours)

                                lastUpdateAvailable = LatestAppUpdate(
                                    minimumOSVersionString: "0.0.0",
                                    urlString: "https://www.example.com",
                                    versionString: "99999.99999.9999",
                                    currentVersionReleaseDate: ISO8601UTC(rawValue: formatter.string(from: releaseDate)),
                                    releaseNotes: String.wtw.random()
                                )
                                
                                let settings = GlobalSettings.wtw.random()
                                    .with(\.lastUpdateAvailable, value: lastUpdateAvailable)
                                    .with(\.lastSeenUpdate, value: nil)

                                state = UpdateWarningState(globalSettings: settings, bundle: bundle)
                            }

                            it("should return show with the last update as the associated value") {
                                expect(state) == .show(lastUpdateAvailable)
                            }
                        }

                        context("when the settings has a lastSeenUpdate") {
                            context("when the last update version is less than the lastSeenUpdate version") {
                                beforeEach {
                                    let formatter = DateFormatters.shared.appleReleaseDateFormatter(for: .current)

                                    let releaseDate = Date.now.addingTimeInterval(-48.hours)

                                    lastUpdateAvailable = LatestAppUpdate(
                                        minimumOSVersionString: "0.0.0",
                                        urlString: "https://www.example.com",
                                        versionString: "22222.22222.22222",
                                        currentVersionReleaseDate: ISO8601UTC(rawValue: formatter.string(from: releaseDate)),
                                        releaseNotes: String.wtw.random()
                                    )

                                    let lastSeenUpdate = LatestAppUpdate(
                                        minimumOSVersionString: "0.0.0",
                                        urlString: "https://www.example.com",
                                        versionString: "99999.99999.9999",
                                        currentVersionReleaseDate: ISO8601UTC(rawValue: formatter.string(from: releaseDate)),
                                        releaseNotes: String.wtw.random()
                                    )

                                    let settings = GlobalSettings.wtw.random()
                                        .with(\.lastUpdateAvailable, value: lastUpdateAvailable)
                                        .with(\GlobalSettings.lastSeenUpdate, value: lastSeenUpdate)

                                    state = UpdateWarningState(globalSettings: settings, bundle: bundle)
                                }

                                it("should return hide") {
                                    expect(state) == .hide
                                }
                            }

                            context("when the last update version is equal to the lastSeenUpdate version") {
                                beforeEach {
                                    let formatter = DateFormatters.shared.appleReleaseDateFormatter(for: .current)

                                    let releaseDate = Date.now.addingTimeInterval(-48.hours)

                                    lastUpdateAvailable = LatestAppUpdate(
                                        minimumOSVersionString: "0.0.0",
                                        urlString: "https://www.example.com",
                                        versionString: "99999.99999.9999",
                                        currentVersionReleaseDate: ISO8601UTC(rawValue: formatter.string(from: releaseDate)),
                                        releaseNotes: String.wtw.random()
                                    )

                                    let lastSeenUpdate = LatestAppUpdate(
                                        minimumOSVersionString: "0.0.0",
                                        urlString: "https://www.example.com",
                                        versionString: "99999.99999.9999",
                                        currentVersionReleaseDate: ISO8601UTC(rawValue: formatter.string(from: releaseDate)),
                                        releaseNotes: String.wtw.random()
                                    )

                                    let settings = GlobalSettings.wtw.random()
                                        .with(\.lastUpdateAvailable, value: lastUpdateAvailable)
                                        .with(\GlobalSettings.lastSeenUpdate, value: lastSeenUpdate)

                                    state = UpdateWarningState(globalSettings: settings, bundle: bundle)
                                }

                                it("should return hide") {
                                    expect(state) == .hide
                                }
                            }

                            context("when the last update version is greater than the lastSeenUpdate version") {
                                beforeEach {
                                    let formatter = DateFormatters.shared.appleReleaseDateFormatter(for: .current)

                                    let releaseDate = Date.now.addingTimeInterval(-48.hours)

                                    lastUpdateAvailable = LatestAppUpdate(
                                        minimumOSVersionString: "0.0.0",
                                        urlString: "https://www.example.com",
                                        versionString: "99999.99999.9999",
                                        currentVersionReleaseDate: ISO8601UTC(rawValue: formatter.string(from: releaseDate)),
                                        releaseNotes: String.wtw.random()
                                    )

                                    let lastSeenUpdate = LatestAppUpdate(
                                        minimumOSVersionString: "0.0.0",
                                        urlString: "https://www.example.com",
                                        versionString: "22222.22222.22222",
                                        currentVersionReleaseDate: ISO8601UTC(rawValue: formatter.string(from: releaseDate)),
                                        releaseNotes: String.wtw.random()
                                    )

                                    let settings = GlobalSettings.wtw.random()
                                        .with(\.lastUpdateAvailable, value: lastUpdateAvailable)
                                        .with(\GlobalSettings.lastSeenUpdate, value: lastSeenUpdate)

                                    state = UpdateWarningState(globalSettings: settings, bundle: bundle)
                                }

                                it("should return show with the last update as the associated value") {
                                    expect(state) == .show(lastUpdateAvailable)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
