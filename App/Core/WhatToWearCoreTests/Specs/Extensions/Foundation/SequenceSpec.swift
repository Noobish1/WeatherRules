import Quick
import Nimble
@testable import WhatToWearCore

internal final class SequenceSpec: QuickSpec {
    internal override func spec() {
        describe("Sequence") {
            describe("its oxfordCommaString") {
                var sequence: [String]!

                context("when the sequence is empty") {
                    beforeEach {
                        sequence = []
                    }

                    it("should return an empty string") {
                        expect(sequence.oxfordCommaString) == ""
                    }
                }

                context("when the sequence is not empty") {
                    context("when the sequence has only one string") {
                        var onlyString: String!

                        beforeEach {
                            onlyString = String.wtw.random()
                            sequence = [onlyString]
                        }

                        it("should return that string") {
                            expect(sequence.oxfordCommaString) == onlyString
                        }
                    }

                    context("when the sequence two strings") {
                        var first: String!
                        var second: String!

                        beforeEach {
                            first = String.wtw.random()
                            second = String.wtw.random()
                            sequence = [first, second]
                        }

                        it("should return the two strings, joined by 'and'") {
                            expect(sequence.oxfordCommaString) == "\(first!) and \(second!)"
                        }
                    }

                    context("when the sequence has more than two strings") {
                        var first: String!
                        var second: String!
                        var third: String!

                        beforeEach {
                            first = String.wtw.random()
                            second = String.wtw.random()
                            third = String.wtw.random()
                            sequence = [first, second, third]
                        }

                        it("should add commas between the strings and an and between the last two") {
                            expect(sequence.oxfordCommaString) == "\(first!), \(second!), and \(third!)"
                        }
                    }
                }
            }

            describe("its all") {
                var sequence: [Int]!

                context("when one of the elements does not satisfy the predicate") {
                    beforeEach {
                        sequence = [1, 2, 3]
                    }

                    it("should return false") {
                        expect(sequence.all { $0 > 1 }).to(beFalse())
                    }
                }

                context("when all of the elements satisfy the predicate") {
                    beforeEach {
                        sequence = [1, 2, 3]
                    }

                    it("should return true") {
                        expect(sequence.all { $0 > 0 }).to(beTrue())
                    }
                }
            }

            describe("its none") {
                var sequence: [Int]!

                context("when one of the elements satisfies the predicate") {
                    beforeEach {
                        sequence = [1, 2, 3]
                    }

                    it("should return false") {
                        expect(sequence.none { $0 == 2 }).to(beFalse())
                    }
                }

                context("when none of the elements satisfy the predicate") {
                    beforeEach {
                        sequence = [1, 2, 3]
                    }

                    it("should return true") {
                        expect(sequence.none { $0 == 4 }).to(beTrue())
                    }
                }
            }

            describe("its any") {
                var sequence: [Int]!

                context("when any of the elements satisfy the predicate") {
                    beforeEach {
                        sequence = [1, 2, 3]
                    }

                    it("should return true") {
                        expect(sequence.any { $0 == 1 }).to(beTrue())
                    }
                }

                context("when none of the elements satisfy the predicate") {
                    beforeEach {
                        sequence = [1, 2, 3]
                    }

                    it("should return false") {
                        expect(sequence.any { $0 == 4}).to(beFalse())
                    }
                }
            }
        }
    }
}
