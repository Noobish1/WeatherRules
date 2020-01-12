import UIKit

extension UICollectionView {
    // MARK: cells
    public func wtw_dequeueReusableCell<T: UICollectionViewCell>(
        identifier: String,
        indexPath: IndexPath
    ) -> T {
        let baseCell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)

        guard let cell = baseCell as? T else {
            fatalError("Could not dequeue a cell of type \(T.self)")
        }

        return cell
    }
}
