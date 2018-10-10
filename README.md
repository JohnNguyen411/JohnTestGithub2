# ios
iOS Driver and Customer repo for Volvo Pickup&amp;Delivery

### Build Status
Master: ![alt text](https://travis-ci.com/volvo-cars/ios.svg?token=pqTNF8RmrhqvQXPCcgH4&branch=master "Master Build status")

Develop: ![alt text](https://travis-ci.com/volvo-cars/ios.svg?token=pqTNF8RmrhqvQXPCcgH4&branch=development "Development Build status")

### Requirements
* swift >= 4
* iOS >= 9.0
* XCode >= 9.0

### Installation
* Clone this repository
* To work on the Customer app, open the `voluxe-customer/voluxe-customer.xcworkspace`  file
* To work on the Driver app, open the `voluxe-driver/voluxe-driver.xcworkspace` file

Note that all dependencies are included in the repo and should not require `pod install` before building the project.

## [Localization Submodule]
The iOS repo contains a submodule (lbv-mobile-strings) to manage localized strings. In order to clone the repo please use `--recursive` like so:

`git clone --recursive git@github.com:volvo-cars/ios.git`.

If you already cloned the project and need to include that submodule:

`git submodule update --init`

To pull everything including the submodules, use the `--recurse-submodules` and the `--remote` parameter in the `git pull` command.

```
# pull all changes in the repo including changes in the submodules
git pull --recurse-submodules

# pull all changes for the submodules
git submodule update --remote
```

If you want to add strings to the twine file, don't forget to push the code in the `lbv-mobile-strings` repo.
Don't forget that any change directly made in a submodule needs to be followed by a commit in the parent directory.

## [Add Language]
- Make sure all translations are provided for your target (`customer`/`driver`) in the Twine file (https://github.com/volvo-cars/lbv-mobile-strings).
- Create the .lproj directory (ex: for french `fr.lproj`) (see lproj language code: https://www.ibabbleon.com/iOS-Language-Codes-ISO-639.html)
- In XCode navigate to the Build Phases tab, and find the already existing twine script. For every language add a twine script line like so:
`twine generate-localization-file ../shared/lbv-mobile-strings/twine.txt voluxe-customer/Localization/fra.lproj/Localizable.strings --tags customer --lang en --format apple`  
- Build the project to generate the `.strings`

### Release
// Todo
