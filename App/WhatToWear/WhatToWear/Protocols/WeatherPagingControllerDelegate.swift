import Foundation

internal protocol WeatherPagingControllerDelegate: AnyObject {
    func pagingController(_ controller: WeatherPagingController, didMoveToPage page: Int)
}
