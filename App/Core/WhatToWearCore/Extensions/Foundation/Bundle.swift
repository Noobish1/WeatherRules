import Foundation

extension Bundle {
    public var version: OperatingSystemVersion {
        let versionString: String = object(forInfoKey: "CFBundleShortVersionString")

        return OperatingSystemVersion.from(string: versionString)
    }

    public var name: String {
        return object(forInfoKey: "CFBundleName")
    }

    internal func object<T>(forInfoKey key: String) -> T {
        guard let object = object(forInfoDictionaryKey: key) as? T else {
            fatalError("Bundle \(self) has no value for info.plist key \(key)")
        }

        return object
    }
}
