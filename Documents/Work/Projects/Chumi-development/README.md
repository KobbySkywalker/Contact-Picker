# Chumi for iOS
Chumi is a Delivery app for Africans!

## Tools
To build and contribute to Chumi for iOS you will need
- [Xcode](https://itunes.apple.com/us/app/xcode/id497799835)
- An ssh key added to your Github account
- [CocoaPods](https://guides.cocoapods.org/using/getting-started.html)

Detailed instructions for installing and using each are below.

## Setup

#### CocoaPods
CocoaPods is built with Ruby and it will be installable with the default Ruby available on macOS. To install CocoaPods enter this in the terminal: `$ sudo gem install cocoapods`

Alternately, you can find the most up to date instructions on the [CocoaPods website](https://guides.cocoapods.org/using/getting-started.html).

#### Xcode
If you've not yet set up your machine for iOS development, make sure Xcode 11 is installed.  Ideally, you would download it directly from [Apple Developer "More Downloads"](https://developer.apple.com/download/more/) to keep old versions around when updates arrive.  It's also available from the App Store.

After initial install, open Xcode to install the Command Line Tools package.

#### SSH
Ensure you have ssh keys on your machine that are added to your local ssh-agent and your Github account. To set up ssh keys follow Github's guide here: [Connecting to Github with SSH](https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh).

## Initial build
Navigate to your desired directory and clone the repository with `https://github.com/FitzAfful/Chumi.git` or `git@github.com:FitzAfful/Chumi.git`
After that navigate to the directory and enter this in the terminal: `$ pod install`.
Open `Chumi.xcworkspace` in Xcode to begin

### Tests
There is a unit test target in the Xcode project.  It's currently a bit sparse.  Great news - that means it's easy to make it way better!  Run the tests with `cmd + u`

## Contributing Code

#### Language
The codebase is entirely Swift. 😍

All new files must be written in Swift.

### Branching Strategy
(This section needs to be updated.  In the mean time, ask a friend for help!)

#### Architecture
The app architecture is MVVM.  

## Deploy to a Local Device
(This section needs to be updated.  In the mean time, ask a friend for help!)


