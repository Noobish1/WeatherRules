import Quick
import Nimble
import WhatToWearCore
@testable import WhatToWearModels

internal final class LatestAppUpdateSpec: QuickSpec {
    internal override func spec() {
        describe("LatestAppUpdate") {
            describe("its minimumOSVersion") {
                var update: LatestAppUpdate!
                var expectedVersion: OperatingSystemVersion!

                beforeEach {
                    let formatter = DateFormatters.shared.appleReleaseDateFormatter(for: .current)

                    let releaseDate = Date.now.addingTimeInterval(-48.hours)

                    expectedVersion = OperatingSystemVersion.wtw.random()
                    update = LatestAppUpdate(
                        minimumOSVersionString: Version(rawValue: expectedVersion!.shortStringRepresentation),
                        urlString: "https://www.example.com",
                        versionString: Version(rawValue: OperatingSystemVersion.wtw.random().shortStringRepresentation),
                        currentVersionReleaseDate: ISO8601UTC(rawValue: formatter.string(from: releaseDate)),
                        releaseNotes: String.wtw.random()
                    )
                }

                it("should return the minimumOSVersionString converted to an OperatingSystemVersion") {
                    expect(update.minimumOSVersion) == expectedVersion
                }
            }

            describe("its version") {
                var update: LatestAppUpdate!
                var expectedVersion: OperatingSystemVersion!

                beforeEach {
                    let formatter = DateFormatters.shared.appleReleaseDateFormatter(for: .current)

                    let releaseDate = Date.now.addingTimeInterval(-48.hours)

                    expectedVersion = OperatingSystemVersion.wtw.random()
                    update = LatestAppUpdate(
                        minimumOSVersionString: Version(rawValue: OperatingSystemVersion.wtw.random().shortStringRepresentation),
                        urlString: "https://www.example.com",
                        versionString: Version(rawValue: expectedVersion!.shortStringRepresentation),
                        currentVersionReleaseDate: ISO8601UTC(rawValue: formatter.string(from: releaseDate)),
                        releaseNotes: String.wtw.random()
                    )
                }

                it("should return the versionString converted to an OperatingSystemVersion") {
                    expect(update.version) == expectedVersion
                }
            }

            describe("its url") {
                var update: LatestAppUpdate!
                var expectedURL: URL!

                beforeEach {
                    let formatter = DateFormatters.shared.appleReleaseDateFormatter(for: .current)

                    let releaseDate = Date.now.addingTimeInterval(-48.hours)

                    expectedURL = URL(string: "https://www.example.com")!
                    update = LatestAppUpdate(
                        minimumOSVersionString: Version(rawValue: OperatingSystemVersion.wtw.random().shortStringRepresentation),
                        urlString: AbsoluteURL(rawValue: expectedURL!.absoluteString),
                        versionString: Version(rawValue: OperatingSystemVersion.wtw.random().shortStringRepresentation),
                        currentVersionReleaseDate: ISO8601UTC(rawValue: formatter.string(from: releaseDate)),
                        releaseNotes: String.wtw.random()
                    )
                }

                it("should return the urlString converted to a URL") {
                    expect(update.url) == expectedURL
                }
            }

            describe("its versionReleaseDate") {
                var update: LatestAppUpdate!
                var expectedDate: Date!

                beforeEach {
                    let formatter = DateFormatters.shared.appleReleaseDateFormatter(for: .current)

                    expectedDate = Date.now.addingTimeInterval(-48.hours)
                    update = LatestAppUpdate(
                        minimumOSVersionString: Version(rawValue: OperatingSystemVersion.wtw.random().shortStringRepresentation),
                        urlString: "https://www.example.com",
                        versionString: Version(rawValue: OperatingSystemVersion.wtw.random().shortStringRepresentation),
                        currentVersionReleaseDate: ISO8601UTC(rawValue: formatter.string(from: expectedDate)),
                        releaseNotes: String.wtw.random()
                    )
                }

                it("should return the urlString converted to a URL") {
                    expect(update.versionReleaseDate).to(beCloseTo(expectedDate, within: 2.minutes))
                }
            }
        }

        describe("its isInstallable") {
            var bundle: Bundle!
            var update: LatestAppUpdate!

            beforeEach {
                bundle = Bundle(for: type(of: self))
            }

            context("when the bundle version is greater than the updates version") {
                beforeEach {
                    let formatter = DateFormatters.shared.appleReleaseDateFormatter(for: .current)

                    let releaseDate = Date.now.addingTimeInterval(-12.hours)

                    update = LatestAppUpdate(
                        minimumOSVersionString: Version(rawValue: OperatingSystemVersion.wtw.random().shortStringRepresentation),
                        urlString: "https://www.example.com",
                        versionString: "0.0.0",
                        currentVersionReleaseDate: ISO8601UTC(rawValue: formatter.string(from: releaseDate)),
                        releaseNotes: String.wtw.random()
                    )
                }

                it("should return false") {
                    expect(update.isInstallable(for: bundle)).to(beFalse())
                }
            }

            context("when the bundle version is equal to the updates version") {
                beforeEach {
                    let formatter = DateFormatters.shared.appleReleaseDateFormatter(for: .current)

                    let releaseDate = Date.now.addingTimeInterval(-12.hours)

                    update = LatestAppUpdate(
                        minimumOSVersionString: Version(rawValue: OperatingSystemVersion.wtw.random().shortStringRepresentation),
                        urlString: "https://www.example.com",
                        versionString: Version(rawValue: bundle.version.shortStringRepresentation),
                        currentVersionReleaseDate: ISO8601UTC(rawValue: formatter.string(from: releaseDate)),
                        releaseNotes: String.wtw.random()
                    )
                }

                it("should return false") {
                    expect(update.isInstallable(for: bundle)).to(beFalse())
                }
            }

            context("when the bundle version is less than the updates version") {
                var operatingSystemVersion: OperatingSystemVersion!

                context("when our OS version is less than the minimum required") {
                    beforeEach {
                        let formatter = DateFormatters.shared.appleReleaseDateFormatter(for: .current)

                        let releaseDate = Date.now.addingTimeInterval(-12.hours)

                        operatingSystemVersion = OperatingSystemVersion(majorVersion: 1, minorVersion: 2, patchVersion: 3)
                        update = LatestAppUpdate(
                            minimumOSVersionString: "999999.999999.999999",
                            urlString: "https://www.example.com",
                            versionString: "999999.999999.999999",
                            currentVersionReleaseDate: ISO8601UTC(rawValue: formatter.string(from: releaseDate)),
                            releaseNotes: String.wtw.random()
                        )
                    }

                    it("should return false") {
                        expect(update.isInstallable(for: bundle, operatingSystemVersion: operatingSystemVersion)).to(beFalse())
                    }
                }

                context("when our OS version is greater than or equal to the minimum required") {
                    context("when the update is less than or equal to 24 hours old") {
                        beforeEach {
                            let formatter = DateFormatters.shared.appleReleaseDateFormatter(for: .current)

                            let releaseDate = Date.now.addingTimeInterval(48.hours)

                            operatingSystemVersion = OperatingSystemVersion(majorVersion: 1, minorVersion: 2, patchVersion: 3)
                            update = LatestAppUpdate(
                                minimumOSVersionString: "0.0.0",
                                urlString: "https://www.example.com",
                                versionString: "999999.999999.999999",
                                currentVersionReleaseDate: ISO8601UTC(rawValue: formatter.string(from: releaseDate)),
                                releaseNotes: String.wtw.random()
                            )
                        }

                        it("should return false") {
                            expect(update.isInstallable(for: bundle, operatingSystemVersion: operatingSystemVersion)).to(beFalse())
                        }
                    }

                    context("when the update is more than 24 hours old") {
                        beforeEach {
                            let formatter = DateFormatters.shared.appleReleaseDateFormatter(for: .current)

                            let releaseDate = Date.now.addingTimeInterval(-48.hours)

                            operatingSystemVersion = OperatingSystemVersion(majorVersion: 1, minorVersion: 2, patchVersion: 3)
                            update = LatestAppUpdate(
                                minimumOSVersionString: "0.0.0",
                                urlString: "https://www.example.com",
                                versionString: "999999.999999.999999",
                                currentVersionReleaseDate: ISO8601UTC(rawValue: formatter.string(from: releaseDate)),
                                releaseNotes: String.wtw.random()
                            )
                        }

                        it("should return true") {
                            expect(update.isInstallable(for: bundle, operatingSystemVersion: operatingSystemVersion)).to(beTrue())
                        }
                    }
                }
            }
        }
    }
}
