import UIKit

extension UIImage {
    public convenience init(color: UIColor, size: CGSize) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)

        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            fatalError("UIGraphicsGetImageFromCurrentImageContext returned nil")
        }

        UIGraphicsEndImageContext()

        guard let cgImage = image.cgImage else {
            fatalError("image.cgImage returned nil for image: \(image)")
        }

        self.init(cgImage: cgImage)
    }

    public convenience init(color: UIColor) {
        self.init(color: color, size: CGSize(width: 1, height: 1))
    }
}
