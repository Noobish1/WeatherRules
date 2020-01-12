import UIKit

internal enum AlertControllers {
    // MARK: Generic alerts
    internal static func okAlert(withTitle title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(
            title: NSLocalizedString("OK", comment: ""),
            style: .default
        ))

        return alert
    }

    // MARK: location fetching
    internal static func locationServicesDisabled(onCancel: @escaping (UIAlertAction) -> Void) -> UIAlertController {
        let title = NSLocalizedString("Location Services Disabled", comment: "")
        let message = NSLocalizedString("We require location services to retrieve your current location. You can enable them in the settings app", comment: "")

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Settings", comment: ""), style: .default, handler: { _ in
            UIApplication.shared.openSettings()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: onCancel))

        return alert
    }

    internal static func locationFetchFailed(
        onRetry: @escaping (UIAlertAction) -> Void,
        onCancel: @escaping (UIAlertAction) -> Void
    ) -> UIAlertController {
        let title = NSLocalizedString("Fetching Current Location Failed", comment: "")
        let message = NSLocalizedString("Either try again or try searching for your location", comment: "")

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Retry", comment: ""), style: .default, handler: onRetry))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: onCancel))

        return alert
    }

    // MARK: Rules
    internal static func ruleInfoAlert() -> UIAlertController {
        return okAlert(
            withTitle: NSLocalizedString("Rules", comment: ""),
            message: NSLocalizedString("Rules determine what you want to wear under certain conditions", comment: "")
        )
    }

    internal static func ruleGroupInfoAlert() -> UIAlertController {
        let message = NSLocalizedString(
        """
            If you have multiple rules that cannot be met at the same time
            rule groups allow you to specify which rule is preferred.
        """, comment: "")

        return okAlert(
            withTitle: NSLocalizedString("Rule Groups", comment: ""),
            message: message
        )
    }

    internal static func priorityInfoAlert() -> UIAlertController {
        let message = NSLocalizedString(
            """
                When multiple rules in a group are met priority determines which rule is preferred.
            """, comment: "")

        return okAlert(
            withTitle: NSLocalizedString("Rule Priority", comment: ""),
            message: message
        )
    }
}
