import Quick
import Nimble
@testable import WhatToWearCore

internal final class OperatingSystemVersionSpec: QuickSpec {
    internal override func spec() {
        describe("OperatingSystemVersion") {
            describe("its init with major, minor, patch") {
                var actual: OperatingSystemVersion!
                var expected: OperatingSystemVersion!
                
                beforeEach {
                    let major = Int.wtw.random()
                    let minor = Int.wtw.random()
                    let patch = Int.wtw.random()
                    actual = OperatingSystemVersion(major, minor, patch)
                    expected = OperatingSystemVersion(
                        majorVersion: major, minorVersion: minor, patchVersion: patch
                    )
                }
                
                it("should return a version with the given components") {
                    expect(actual) == expected
                }
            }
            
            describe("its from string") {
                context("when there are zero parts") {
                    it("should fatalError") {
                        expect(expression: {
                            _ = OperatingSystemVersion.from(string: "")
                        }).to(throwAssertion())
                    }
                }
                
                context("when there are at least one part") {
                    context("when one of the parts cannot be converted to an Int") {
                        it("should fatalError") {
                            expect(expression: {
                                _ = OperatingSystemVersion.from(string: "a")
                            }).to(throwAssertion())
                        }
                    }
                    
                    context("when all the parts are valid") {
                        context("when there is less than three valid parts") {
                            var actual: OperatingSystemVersion!
                            var expected: OperatingSystemVersion!
                            
                            beforeEach {
                                let part = Int.wtw.random()
                                
                                actual = OperatingSystemVersion.from(string: "\(part)")
                                expected = OperatingSystemVersion(part, 0, 0)
                            }
                            
                            it("should pad the one part with zeros") {
                                expect(actual) == expected
                            }
                        }
                        
                        context("when there is three parts") {
                            var actual: OperatingSystemVersion!
                            var expected: OperatingSystemVersion!
                            
                            beforeEach {
                                let major = Int.wtw.random()
                                let minor = Int.wtw.random()
                                let patch = Int.wtw.random()
                                
                                actual = OperatingSystemVersion.from(string: "\(major).\(minor).\(patch)")
                                expected = OperatingSystemVersion(major, minor, patch)
                            }
                            
                            it("should return the correct version") {
                                expect(actual) == expected
                            }
                        }
                    }
                }
            }
            
            describe("its ExpressibleByStringLiteral conformance") {
                var actual: OperatingSystemVersion!
                var expected: OperatingSystemVersion!
                
                beforeEach {
                    actual = "4.1.9"
                    expected = OperatingSystemVersion(4, 1, 9)
                }
                
                it("should return the correct version") {
                    expect(actual) == expected
                }
            }
            
            describe("its ShortStringRepresentable") {
                var actual: String!
                var expected: String!
                
                beforeEach {
                    let version = OperatingSystemVersion.wtw.random()
                    
                    actual = version.shortStringRepresentation
                    expected = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
                }
                
                it("should return the version as a string") {
                    expect(actual) == expected
                }
            }
            
            describe("its Equatable conformance") {
                context("when two versions are not equal") {
                    var lhs: OperatingSystemVersion!
                    var rhs: OperatingSystemVersion!
                    
                    beforeEach {
                        lhs = OperatingSystemVersion(1, 2, 3)
                        rhs = OperatingSystemVersion(3, 2, 1)
                    }
                    
                    it("should return false") {
                        expect(lhs == rhs).to(beFalse())
                    }
                }
                
                context("when two versions are equal") {
                    var version: OperatingSystemVersion!
                    
                    beforeEach {
                        version = OperatingSystemVersion(1, 2, 3)
                    }
                    
                    it("should return false") {
                        expect(version == version).to(beTrue())
                    }
                }
            }
            
            describe("its Comparable conformance") {
                var lhs: OperatingSystemVersion!
                var rhs: OperatingSystemVersion!
                
                context("when the lhs precedes the rhs") {
                    beforeEach {
                        lhs = OperatingSystemVersion(1, 0, 0)
                        rhs = OperatingSystemVersion(1, 0, 1)
                    }
                    
                    it("should return true") {
                        expect(lhs < rhs).to(beTrue())
                    }
                }
                
                context("when the lhs does not precede the rhs") {
                    beforeEach {
                        lhs = OperatingSystemVersion(2, 4, 5)
                        rhs = OperatingSystemVersion(1, 0, 1)
                    }
                    
                    it("should return false") {
                        expect(lhs < rhs).to(beFalse())
                    }
                }
            }
            
            describe("its Codable conformance") {
                var expected: OperatingSystemVersion!
                var actual: OperatingSystemVersion!
                
                beforeEach {
                    expected = OperatingSystemVersion.wtw.random()
                    
                    let data = try! JSONEncoder().encode(expected)
                
                    actual = try! JSONDecoder().decode(OperatingSystemVersion.self, from: data)
                }
                
                it("should encode and decode correctly") {
                    expect(actual) == expected
                }
            }
        }
    }
}
