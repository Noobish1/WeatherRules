import Foundation

// MARK: ContainerDecodable
public protocol ContainerDecodable: Decodable {
    associatedtype CodingKeys: ContainerCodingKey
    
    init(from container: KeyedDecodingContainer<CodingKeys>) throws
}

// MARK: Extensions
extension ContainerDecodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        try self.init(from: container)
    }
}
