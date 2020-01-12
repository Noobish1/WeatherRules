## How to test Update warnings

In `UpdateWarningState.swift` replace the implementation of `init(globalSettings: GlobalSettings, bundle: Bundle = .main)` with:

```swift
    if let lastUpdate = globalSettings.lastUpdateAvailable {
        self = .show(lastUpdate)
        
        return
    } else {
        self = .hide
    }
```
