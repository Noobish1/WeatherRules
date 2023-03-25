![WeatherRules Header Image](readme-assets/repo-header.png)

![Screenshots](readme-assets/screenshots.png)

![iTunes App Store](https://img.shields.io/itunes/v/1418841967)
![GitHub top language](https://img.shields.io/github/languages/top/Noobish1/WeatherRules)
![GitHub](https://img.shields.io/github/license/Noobish1/WeatherRules)
![Bitrise](https://img.shields.io/bitrise/b5a1458389444052/public-master?token=edhPAmgQBXB2viNn9venKw)
[![Maintainability](https://api.codeclimate.com/v1/badges/26c43e8006e2c6ea1155/maintainability)](https://codeclimate.com/github/Noobish1/WeatherRules/maintainability)

This repo contains the entire WeatherRules iOS app, that was available on the iOS App Store until Apple shutdown the Dark Sky API and replaced it with WeatherKit.

This repo is meant as a portfolio piece and an example of my code, you won't be able to just build and run it as it's missing API Keys among other things.

## Screenshots

<details>
<summary>iPhone X Screenshots</summary>

![Today Forecast](readme-assets/screenshots/iphone-x/1-today-forecast-iPhone-x.png)
![Measurements](readme-assets/screenshots/iphone-x/2-measurements-iPhone-x.png)
![Conditions](readme-assets/screenshots/iphone-x/3-conditions-iPhone-x.png)
![Rules](readme-assets/screenshots/iphone-x/4-rules-iPhone-x.png)
![Today Extensions](readme-assets/screenshots/iphone-x/5-today-extensions-iPhone-x.png)
![Time Settings](readme-assets/screenshots/iphone-x/6-time-settings-iPhone-x.png)
![Rule Groups](readme-assets/screenshots/iphone-x/7-rule-groups-iPhone-x.png)
![Past Forecasts](readme-assets/screenshots/iphone-x/8-past-forecasts-iPhone-x.png)
![Future Forecasts](readme-assets/screenshots/iphone-x/9-future-forecasts-iPhone-x.png)
![Settings](readme-assets/screenshots/iphone-x/10-settings-iPhone-x.png)

</details>

<details>
<summary>iPhone 8 Plus Screenshots</summary>

![Today Forecast](readme-assets/screenshots/iphone-8-plus/1-today-forecast-iPhone-8-plus.png)
![Measurements](readme-assets/screenshots/iphone-8-plus/2-measurements-iPhone-8-plus.png)
![Conditions](readme-assets/screenshots/iphone-8-plus/3-conditions-iPhone-8-plus.png)
![Rules](readme-assets/screenshots/iphone-8-plus/4-rules-iPhone-8-plus.png)
![Today Extensions](readme-assets/screenshots/iphone-8-plus/5-today-extensions-iPhone-8-plus.png)
![Time Settings](readme-assets/screenshots/iphone-8-plus/6-time-settings-iPhone-8-plus.png)
![Rule Groups](readme-assets/screenshots/iphone-8-plus/7-rule-groups-iPhone-8-plus.png)
![Past Forecasts](readme-assets/screenshots/iphone-8-plus/8-past-forecasts-iPhone-8-plus.png)
![Future Forecasts](readme-assets/screenshots/iphone-8-plus/9-future-forecasts-iPhone-8-plus.png)
![Settings](readme-assets/screenshots/iphone-8-plus/10-settings-iPhone-8-plus.png)

</details>

<details>
<summary>iPad Screenshots</summary>

![Today Forecast](readme-assets/screenshots/ipad/1-today-forecast-ipad.png)
![Measurements](readme-assets/screenshots/ipad/2-measurements-ipad.png)
![Conditions](readme-assets/screenshots/ipad/3-conditions-ipad.png)
![Rules](readme-assets/screenshots/ipad/4-rules-ipad.png)
![Today Extensions](readme-assets/screenshots/ipad/5-today-extensions-ipad.png)
![Time Settings](readme-assets/screenshots/ipad/6-time-settings-ipad.png)
![Rule Groups](readme-assets/screenshots/ipad/7-rule-groups-ipad.png)
![Past Forecasts](readme-assets/screenshots/ipad/8-past-forecasts-ipad.png)
![Future Forecasts](readme-assets/screenshots/ipad/9-future-forecasts-ipad.png)
![Settings](readme-assets/screenshots/ipad/10-settings-ipad.png)

</details>

## Organisation

![Architecture diagram](readme-assets/architecture.png)

The app is split into a number of frameworks/targets

* `WhatToWear`: Main App Target
* `RulesExtension`: Rules Today Extension
* `ForecastExtension`: Forecast Today Extension
* `ExtensionCore`: Code that is shared between the Today Extensions
* `CoreUI`: Reuseable UI components
* `Assets`: Images used throughout the app
* `Charts`: Components used for making charts/graphs
* `Networking`: Networking components for making API calls primarily
* `CoreComponents`: Common objects used in multiple places that don't fit elsewhere
* `Models`: Model objects, whether they be from the DarkSky API or elsewhere
* `CommonModels`: Shared Models between this app and an in progress Swift Backend component, repo is [here](https://github.com/Noobish1/WhatToWearCommonModels)
* `Core`: Mostly Extensions of Apple frameworks that are used everywhere
* `CommonCore`: Shared Extensions of Apple frameworks between this app and an in progress Swift Backend component, repo is [here](https://github.com/Noobish1/WhatToWearCommonCore)
* `ErrorRecorder`: Wrapper for sending non-fatal errors to AppCenter (as custom events) as well as Analytics
* `Environment`: Splitting Dev/Prod environments

## Other Highlights

### Unit tests

There is a small-ish test suite of ~300 tests using the [Quick](https://github.com/Quick/Quick) and [Nimble](https://github.com/Quick/Nimble) BDD frameworks.

* [CoreTests](App/Core/WhatToWearCoreTests)
* [ModelsTests](App/Models/WhatToWearModelsTests)
* [CoreComponentsTests](App/CoreComponents/WhatToWearCoreComponentsTests)

Tests in other repos

* [CommonCoreTests](https://github.com/Noobish1/WhatToWearCommonCore/tree/master/WhatToWearCommonCoreTests)
* [CommonModelsTests](https://github.com/Noobish1/WhatToWearCommonCore/tree/master/WhatToWearCommonCoreTests)

### Assets

All images (except App Icons and Launch images) are in the `Assets` framework and I use [R.swift](https://github.com/mac-cain13/R.swift) for compile-time checking of them.

### Linting

I use [SwiftLint](https://github.com/realm/SwiftLint) to lint this project, the config file can be found [here](App/.swiftlint.yml).

## Usage

If you really want to build and run it you'll need to sort out:

* DarkSky API Keys
* AppCenter API Keys
* Code-signing settings

