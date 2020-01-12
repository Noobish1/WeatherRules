import Foundation

public protocol FixtureProtocol {
    associatedtype EnclosingType: Decodable
    
    var url: URL { get }
    
    func fixtureData() throws -> Data
    func object(decoder: JSONDecoder) throws -> EnclosingType
}

extension FixtureProtocol {
    // MARK: objects
    public func object(decoder: JSONDecoder = .init()) throws -> EnclosingType {
        let data = try fixtureData()
        
        return try decoder.decode(EnclosingType.self, from: data)
    }
    
    // MARK: data
    public func fixtureData() throws -> Data {
        return try Data(contentsOf: url)
    }
}
