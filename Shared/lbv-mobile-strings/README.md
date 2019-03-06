# lbv-mobile-strings
Luxe By Volvo Mobile localized Strings

This project is currently being used by the Luxe By Volvo Customer/Driver Android and iOS projects:
- https://github.com/volvo-cars/android
- https://github.com/volvo-cars/ios


## [Setup Process]
To add this repo as a submodule please follow this instructions:
```
# add submodule and define the master branch as the one you want to track
git submodule add -b master [URL to Git repo]
git submodule init
```

If you make modification to any existing key, please verify with the teams already using this project and do not push the code directly on Master but use PR (mandatory).

## [Contributions]

If you want to add a string:
- please add with at least the base language (`en`).
- tag it with `customer` or `driver` or both: `customer,driver`
- use sections with `[[Section]]` it creates a section in the generated string file
- please use generic keys for the generic strings like: `ok`, `yes`, `no` etc. And more specific keys for view related items like: `viewScheduledServiceInRoute`, etc.
- Use PR only and ask for someone to review it, not push directly on Master