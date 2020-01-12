import Foundation

extension Dictionary {
    public mutating func value(
        forKey key: Key,
        orInsertAndReturn newValueClosure: @autoclosure () -> Value
    ) -> Value {
        guard let cachedValue = self[key] else {
            let newValue = newValueClosure()
            
            self[key] = newValue
            
            return newValue
        }
        
        return cachedValue
    }
}
