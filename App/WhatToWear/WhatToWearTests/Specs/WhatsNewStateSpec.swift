import Nimble
import Quick
@testable import WeatherRules
import WhatToWearModels
import WhatToWearModelsTesting
import WhatToWearCore
import WhatToWearCommonCore

internal final class WhatsNewStateSpec: QuickSpec {
    internal override func spec() {
        describe("WhatsNewState") {
            describe("its init") {
                var state: WhatsNewState!

                context("when the user has whatsNewOnLaunch set to false") {
                    beforeEach {
                        let settings = GlobalSettings.wtw.random()
                            .with(\.whatsNewOnLaunch, value: false)
                        
                        state = WhatsNewState(
                            settings: settings,
                            appVersion: OperatingSystemVersion.wtw.random(),
                            content: WhatsNewContentViewModel(),
                            recentlySelectedLocation: true
                        )
                    }
                    
                    it("should return hidesWhatsNew with updateSettings set to true") {
                        expect(state) == .hideWhatsNew(updateSettings: true)
                    }
                }
                
                context("when the user has whatsNewOnLaunch set to true") {
                    context("when the location is recently selected") {
                        beforeEach {
                            let settings = GlobalSettings.wtw.random()
                                .with(\.whatsNewOnLaunch, value: true)

                            state = WhatsNewState(
                                settings: settings,
                                appVersion: OperatingSystemVersion.wtw.random(),
                                content: WhatsNewContentViewModel(),
                                recentlySelectedLocation: true
                            )
                        }

                        it("should return hidesWhatsNew with updateSettings set to true") {
                            expect(state) == .hideWhatsNew(updateSettings: true)
                        }
                    }

                    context("when the location is not recently selected") {
                        context("when the app version is less than or equal to the last seen version") {
                            beforeEach {
                                let settings = GlobalSettings.wtw.random()
                                    .with(\.whatsNewOnLaunch, value: true)
                                    .with(\.lastWhatsNewVersionSeen, value: OperatingSystemVersion(1, 0, 0))

                                state = WhatsNewState(
                                    settings: settings,
                                    appVersion: OperatingSystemVersion(0, 0, 0),
                                    content: WhatsNewContentViewModel(),
                                    recentlySelectedLocation: false
                                )
                            }

                            it("should return hidesWhatsNew with updateSettings set to false") {
                                expect(state) == .hideWhatsNew(updateSettings: false)
                            }
                        }

                        context("when the app version is greater than the last seen version") {
                            context("when when we do not have whatsNew content to show") {
                                beforeEach {
                                    let content = WhatsNewContentViewModel(
                                        updates: NonEmptyArray(elements:
                                            WhatsNewUpdateViewModel(
                                                version: OperatingSystemVersion(2, 0, 0),
                                                segments: NonEmptyArray(elements:
                                                    WhatsNewSegmentViewModel(
                                                        title: String.wtw.random(),
                                                        subtitle: String.wtw.random()
                                                    )
                                                )
                                            )
                                        )
                                    )

                                    let settings = GlobalSettings.wtw.random()
                                        .with(\.whatsNewOnLaunch, value: true)
                                        .with(\.lastWhatsNewVersionSeen, value: OperatingSystemVersion(0, 0, 0))

                                    state = WhatsNewState(
                                        settings: settings,
                                        appVersion: OperatingSystemVersion(1, 0, 0),
                                        content: content,
                                        recentlySelectedLocation: false
                                    )
                                }

                                it("should return hidesWhatsNew with updateSettings set to false") {
                                    expect(state) == .hideWhatsNew(updateSettings: false)
                                }
                            }

                            context("when we do have whatsNew content to show") {
                                beforeEach {
                                    let version = OperatingSystemVersion(1, 0, 0)

                                    let content = WhatsNewContentViewModel(
                                        updates: NonEmptyArray(elements:
                                            WhatsNewUpdateViewModel(
                                                version: version,
                                                segments: NonEmptyArray(elements:
                                                    WhatsNewSegmentViewModel(
                                                        title: String.wtw.random(),
                                                        subtitle: String.wtw.random()
                                                    )
                                                )
                                            )
                                        )
                                    )

                                    let settings = GlobalSettings.wtw.random()
                                        .with(\.whatsNewOnLaunch, value: true)
                                        .with(\.lastWhatsNewVersionSeen, value: OperatingSystemVersion(0, 0, 0))

                                    state = WhatsNewState(
                                        settings: settings,
                                        appVersion: version,
                                        content: content,
                                        recentlySelectedLocation: false
                                    )
                                }

                                it("should return showWhatsNew") {
                                    expect(state) == .showWhatsNew
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
