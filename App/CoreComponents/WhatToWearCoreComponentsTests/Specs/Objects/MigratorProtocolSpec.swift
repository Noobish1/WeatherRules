import Quick
import Nimble
import WhatToWearModels
@testable import WhatToWearCoreComponents

private struct TestObject: Codable, DefaultsBackedObject {
    fileprivate typealias Version = TestObjectVersion

    fileprivate var migrationsRun: [TestObjectVersion] = []

    fileprivate static var `default`: Self {
        return Self()
    }
}

private final class TestObjectMigrator: MigratorProtocol {
    fileprivate typealias Object = TestObject
    
    fileprivate func migrationToNextVersion(from version: Object.Version) -> Migration {
        // Normally you'd switch on self but we use self below
        return .custom({ data in
            let decoder = JSONDecoder()
            let encoder = JSONEncoder()

            let oldObject = try decoder.decode(TestObject.self, from: data)

            let newObject = TestObject(
                migrationsRun: oldObject.migrationsRun.byAppending(version)
            )

            return try encoder.encode(newObject)
        })
    }
}

private enum TestObjectVersion: String, DefaultsVersionProtocol, Codable {
    case first = "first"
    case second = "second"
    case third = "third"
    case fourth = "fourth"

    fileprivate static let defaultVersion: Self = .first
}

internal final class MigratorSpec: QuickSpec {
    internal override func spec() {
        describe("MigratorProtocol") {
            describe("its migrate") {
                var actualObject: TestObject!
                var expectedVersions: [TestObjectVersion]!
                
                beforeEach {
                    let migrator = TestObjectMigrator()
                    
                    let decoder = JSONDecoder()
                    let encoder = JSONEncoder()

                    let beforeObject = TestObject()
                    let beforeData = try! encoder.encode(beforeObject)

                    let startVersionIndex = TestObjectVersion.allCases.randomIndex()!

                    let afterData = try! migrator.migrate(
                        data: beforeData,
                        from: TestObjectVersion.allCases[startVersionIndex]
                    )

                    actualObject = try! decoder.decode(TestObject.self, from: afterData)
                    expectedVersions = Array(TestObjectVersion.allCases[startVersionIndex...])
                }

                it("should run each migration from the given version to the latest version") {
                    expect(actualObject.migrationsRun).to(contain(expectedVersions))
                }
            }
        }
    }
}
