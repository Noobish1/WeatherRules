import Quick
import Nimble
import WhatToWearModels
import WhatToWearModelsTesting
@testable import WhatToWearCoreComponents

internal final class GlobalSettingsVersionSpec: QuickSpec {
    internal override func spec() {
        describe("GlobalSettingsMigrator") {
            describe("its migrationToNextVersion") {
                var migrator: GlobalSettingsMigrator!
                
                beforeEach {
                    migrator = GlobalSettingsMigrator()
                }
                
                context("when we are the initial version") {
                    context("when the old data contains OldGlobalSettings") {
                        context("its returned settings") {
                            var oldSettings: OldGlobalSettings!
                            var newSettings: PreBackgroundsGlobalSettings!
                            var expectedShownComponents: [WeatherChartComponent: Bool]!

                            beforeEach {
                                let encoder = JSONEncoder()
                                let decoder = JSONDecoder()

                                oldSettings = OldGlobalSettings.wtw.random()
                                let oldData = try! encoder.encode(oldSettings)

                                let newData = try! migrator.migrationToNextVersion(from: .initial).perform(from: oldData)

                                newSettings = try! decoder.decode(PreBackgroundsGlobalSettings.self, from: newData)

                                expectedShownComponents = Dictionary(uniqueKeysWithValues: WeatherChartComponent.allCases.map { component in
                                    guard case .initial = component.versionWhenAdded else {
                                        return (component, component.shownByDefault)
                                    }

                                    return (component, oldSettings.shownComponents.contains(component))
                                })
                            }

                            it("should have the same measurementSystem as the oldSettings") {
                                expect(newSettings.measurementSystem) == oldSettings.measurementSystem
                            }

                            it("should have components enabled if they were in the oldSettings or if they are shownByDefault") {
                                expect(newSettings.shownComponents) == expectedShownComponents
                            }
                        }
                    }

                    context("when the old data contains PreComponentsGlobalSettings") {
                        var oldSettings: PreComponentsGlobalSettings!
                        var newSettings: PreBackgroundsGlobalSettings!

                        beforeEach {
                            let encoder = JSONEncoder()
                            let decoder = JSONDecoder()

                            oldSettings = PreComponentsGlobalSettings(
                                measurementSystem: MeasurementSystem.nonEmptyCases.randomElement()
                            )
                            let oldData = try! encoder.encode(oldSettings)

                            let newData = try! migrator.migrationToNextVersion(from: .initial).perform(from: oldData)

                            newSettings = try! decoder.decode(PreBackgroundsGlobalSettings.self, from: newData)
                        }

                        context("its returned settings") {
                            it("should have the same measurementSystem as the oldSettings") {
                                expect(newSettings.measurementSystem) == oldSettings.measurementSystem
                            }

                            it("should have the defaultMapping for shownComponents") {
                                expect(newSettings.shownComponents) == WeatherChartComponent.defaultMapping
                            }
                        }
                    }
                }

                context("when we are the rulesSetToRulesDict version") {
                    var oldSettings: PreBackgroundsGlobalSettings!
                    var newSettings: PreUpdatesGlobalSettings!

                    beforeEach {
                        let encoder = JSONEncoder()
                        let decoder = JSONDecoder()

                        oldSettings = PreBackgroundsGlobalSettings.wtw.random()
                        let oldData = try! encoder.encode(oldSettings)

                        let newData = try! migrator.migrationToNextVersion(from: .rulesSetToRulesDict).perform(from: oldData)

                        newSettings = try! decoder.decode(PreUpdatesGlobalSettings.self, from: newData)
                    }

                    context("its returned settings") {
                        it("should have the same measurementSystem as the oldSettings") {
                            expect(newSettings.measurementSystem) == oldSettings.measurementSystem
                        }

                        it("should have the same shownComponents as the oldSettings") {
                            expect(newSettings.shownComponents) == oldSettings.shownComponents
                        }

                        it("should have the original appBackgroundOptions") {
                            expect(newSettings.appBackgroundOptions) == .original
                        }
                    }
                }

                context("when we are the addedBackgrounds version") {
                    var oldSettings: PreUpdatesGlobalSettings!
                    var newSettings: PreWhatsNewGlobalSettings!

                    beforeEach {
                        let encoder = JSONEncoder()
                        let decoder = JSONDecoder()

                        oldSettings = PreUpdatesGlobalSettings.wtw.random()
                        let oldData = try! encoder.encode(oldSettings)
                        
                        let newData = try! migrator.migrationToNextVersion(from: .addedBackgrounds).perform(from: oldData)

                        newSettings = try! decoder.decode(PreWhatsNewGlobalSettings.self, from: newData)
                    }

                    context("its returned settings") {
                        it("should have the same measurementSystem as the oldSettings") {
                            expect(newSettings.measurementSystem) == oldSettings.measurementSystem
                        }

                        it("should have the same shownComponents as the oldSettings") {
                            expect(newSettings.shownComponents) == oldSettings.shownComponents
                        }

                        it("should have the same appBackgroundOptions as the oldSettings") {
                            expect(newSettings.appBackgroundOptions) == oldSettings.appBackgroundOptions
                        }

                        it("should have its lastSeenUpdate set to nil") {
                            expect(newSettings.lastSeenUpdate).to(beNil())
                        }

                        it("should have its lastUpdateAvailable set to nil") {
                            expect(newSettings.lastUpdateAvailable).to(beNil())
                        }
                    }
                }

                context("when we are the addedUpdates version") {
                    var oldSettings: PreWhatsNewGlobalSettings!
                    var newSettings: PreExtraConfigGlobalSettings!

                    beforeEach {
                        let encoder = JSONEncoder()
                        let decoder = JSONDecoder()

                        oldSettings = PreWhatsNewGlobalSettings.wtw.random()
                        let oldData = try! encoder.encode(oldSettings)

                        let newData = try! migrator.migrationToNextVersion(from: .addedUpdates).perform(from: oldData)

                        newSettings = try! decoder.decode(PreExtraConfigGlobalSettings.self, from: newData)
                    }

                    context("its returned settings") {
                        it("should have the same measurementSystem as the oldSettings") {
                            expect(newSettings.measurementSystem) == oldSettings.measurementSystem
                        }

                        it("should have the same shownComponents as the oldSettings") {
                            expect(newSettings.shownComponents) == oldSettings.shownComponents
                        }

                        it("should have the same appBackgroundOptions as the oldSettings") {
                            expect(newSettings.appBackgroundOptions) == oldSettings.appBackgroundOptions
                        }

                        it("should have the same lastSeenUpdate as the oldSettings") {
                            // I have to do this because if the left side is nil is decides it doesn't want to do ==
                            // Since the globalsettings are random, we have to handle both side
                            if oldSettings.lastSeenUpdate == nil {
                                expect(newSettings.lastSeenUpdate).to(beNil())
                            } else {
                                expect(newSettings.lastSeenUpdate) == oldSettings.lastSeenUpdate
                            }
                        }

                        it("should have the same lastUpdateAvailable as the oldSettings") {
                            // I have to do this because if the left side is nil is decides it doesn't want to do ==
                            // Since the globalsettings are random, we have to handle both side
                            if oldSettings.lastUpdateAvailable == nil {
                                expect(newSettings.lastUpdateAvailable).to(beNil())
                            } else {
                                expect(newSettings.lastUpdateAvailable) == oldSettings.lastUpdateAvailable
                            }
                        }

                        it("should have lastWhatsNewVersionSeen set to the default") {
                            expect(newSettings.lastWhatsNewVersionSeen) == GlobalSettings.default.lastWhatsNewVersionSeen
                        }
                    }
                }

                context("when we are the addedWhatsNew version") {
                    var oldSettings: PreExtraConfigGlobalSettings!
                    var newSettings: GlobalSettings!
                    
                    beforeEach {
                        let encoder = JSONEncoder()
                        let decoder = JSONDecoder()
                        
                        oldSettings = PreExtraConfigGlobalSettings.wtw.random()
                        let oldData = try! encoder.encode(oldSettings)
                        
                        let newData = try! migrator.migrationToNextVersion(from: .addedWhatsNew).perform(from: oldData)
                        
                        newSettings = try! decoder.decode(GlobalSettings.self, from: newData)
                    }
                    
                    context("its returned settings") {
                        it("should have the same measurementSystem as the oldSettings") {
                            expect(newSettings.measurementSystem) == oldSettings.measurementSystem
                        }
                        
                        it("should have the same shownComponents as the oldSettings") {
                            expect(newSettings.shownComponents) == oldSettings.shownComponents
                        }
                        
                        it("should have the same appBackgroundOptions as the oldSettings") {
                            expect(newSettings.appBackgroundOptions) == oldSettings.appBackgroundOptions
                        }
                        
                        it("should have the same lastSeenUpdate as the oldSettings") {
                            // I have to do this because if the left side is nil is decides it doesn't want to do ==
                            // Since the globalsettings are random, we have to handle both side
                            if oldSettings.lastSeenUpdate == nil {
                                expect(newSettings.lastSeenUpdate).to(beNil())
                            } else {
                                expect(newSettings.lastSeenUpdate) == oldSettings.lastSeenUpdate
                            }
                        }
                        
                        it("should have the same lastUpdateAvailable as the oldSettings") {
                            // I have to do this because if the left side is nil is decides it doesn't want to do ==
                            // Since the globalsettings are random, we have to handle both side
                            if oldSettings.lastUpdateAvailable == nil {
                                expect(newSettings.lastUpdateAvailable).to(beNil())
                            } else {
                                expect(newSettings.lastUpdateAvailable) == oldSettings.lastUpdateAvailable
                            }
                        }
                        
                        it("should have lastWhatsNewVersionSeen set to the default") {
                            expect(newSettings.lastWhatsNewVersionSeen) == oldSettings.lastWhatsNewVersionSeen
                        }
                        
                        it("should have temperatureType set to the default") {
                            expect(newSettings.temperatureType) == GlobalSettings.default.temperatureType
                        }
                        
                        it("should have windType set to the default") {
                            expect(newSettings.windType) == GlobalSettings.default.windType
                        }
                        
                        it("should have whatsNewOnLaunch set to the default") {
                            expect(newSettings.whatsNewOnLaunch) == GlobalSettings.default.whatsNewOnLaunch
                        }
                    }
                }
                
                context("when we are the addedExtraConfig version") {
                    var oldSettings: GlobalSettings!
                    var newSettings: GlobalSettings!

                    beforeEach {
                        let encoder = JSONEncoder()
                        let decoder = JSONDecoder()

                        oldSettings = GlobalSettings.wtw.random()
                        let oldData = try! encoder.encode(oldSettings)

                        let newData = try! migrator.migrationToNextVersion(from: .addedExtraConfig).perform(from: oldData)

                        newSettings = try! decoder.decode(GlobalSettings.self, from: newData)
                    }

                    it("should do nothing") {
                        expect(newSettings) == oldSettings
                    }
                }
            }
            
            describe("its migrate from almost the initial version to the latest version") {
                var oldSettings: PreComponentsGlobalSettings!
                var newSettings: GlobalSettings!
                var expectedSettings: GlobalSettings!
                
                beforeEach {
                    let encoder = JSONEncoder()
                    let decoder = JSONDecoder()

                    oldSettings = PreComponentsGlobalSettings(
                        measurementSystem: MeasurementSystem.wtw.random()
                    )
                    let oldData = try! encoder.encode(oldSettings)

                    let newData = try! GlobalSettingsMigrator().migrate(
                        data: oldData,
                        from: GlobalSettingsVersion.initial
                    )

                    newSettings = try! decoder.decode(GlobalSettings.self, from: newData)

                    // We're migrating so using the original appBackgroundOptions makes sense
                    expectedSettings = GlobalSettings.default
                        .with(\.measurementSystem, value: oldSettings.measurementSystem)
                        .with(\.appBackgroundOptions, value: .original)
                }

                context("its returned settings") {
                    it("should be equal to the default settings except for the old measurementSystem being the same") {
                        expect(newSettings) == expectedSettings
                    }
                }
            }
        }
    }
}
