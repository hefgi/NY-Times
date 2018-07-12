README

# Run
- Change Team and bundle identifier
- Run & Build
- Enjoy

# Features 
- API class : `NYTimesAPI`
- MVC pattern used (recommanded by Apple)
- Ready to fetch others section or period (see `Parameters` struct). 
- Modular enough to add others calls from NY Times API.
- Ready for background fetch (using `URLSession` with delegate).
- Models are using `Codable` protocol  (new in swift 4) : JSON parsing is quick and easy.
- 100% swift & No librairies used.
- Protocol `ReusedCell` to adopt a convention that the cell identifier is the same as the cell class name
- Logo + Splashscreen
- Unit Testing using XCTest
- UI Testing using XCUITest

For the sake of the coding assignment, I choose to not use any libraries. However, it would be probably a better choice to use AlamoFire and avoid the maintenance of the `NYTimesAPI` file.

# TODO / IMPROVMENTS 
- Loading
- Add missing data to Codable models (Medias etc…)
- Add choose sections & period
- Handle background fetch
- Generic DataSource (see here : https://medium.com/capital-one-developers/generic-data-sources-in-swift-c6fbb531520e)
- `PersistenceStore` class for local storage (should be easy to save json/plist objects into document directory since models are using Codable)
- Use TDD (test driven development)
- Article object Mocking
- Linting
- Use generic protocols for accesibilityIdentifier property for UI Testing

# Code Coverage
Just need to run Test on Xcode ( cmd+U )

## Unit Testing
Unit testing is done by using XCTest
I could do more and do mocking or Article

## UI Testing
UI Testing is done by using XCUITest
We should do more, and run this UI tests on device farms (I suggest AWS : https://aws.amazon.com/device-farm/)

## Mocking
Great read : 
https://medium.com/@johnsundell/mocking-in-swift-56a913ee7484
https://academy.realm.io/posts/tryswift-veronica-ray-real-world-mocking-swift/

Writing our own mock object seems the way to go in swift : 
“Swift is currently read-only; there is no way to modify your program at run time. That doesn’t seem like it will change, which is part of what makes Swift such a safe programming language. Swift does have some mocking frameworks currently, but they are different than what you would find in languages with more access to the language run-time.
As a result, we will need to write our own mocks.”

Problem is, it takes to time to write them and maintain them.

# Good practices

## Linting
Linting is not implemented yet. Consider using SwiftLint (https://github.com/realm/SwiftLint) or SwiftFormat (https://github.com/nicklockwood/SwiftFormat).

## Swift Styleguide
Here's a good styleguide to follow, created by Google : https://google.github.io/swift/

## Code review / Git flow
As good practices we should create Pull request and developers should at least have one approved review to be merged. Also the use of the git flow methodology is should be requiered.

# Automation 
I didn't have enough time to create an example of automation process. 

## CI

- Bitrise
- Xcode server
- Jenkins
- Microsoft AppCenter

## CD 
- HockeyApp
- Fabric

## Tools
- Fastlane

