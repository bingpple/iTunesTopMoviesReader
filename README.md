# How To

## 1.Download the code
### Run the git command below to download the code
```Bash
git clone https://github.com/bingpple/iTunesTopMoviesReader.git
```
## 2.Go to iTunesTopMoviesReader folder
```Bash
cd iTunesTopMoviesReader
```
## 3.Install Pod if you don't have it
```Bash
sudo gem install cocoapods
```
## 4.Run pod init
```Bash
pod init
```
## 5.Edit PodFile file to pod [FeedKit](https://github.com/nmdias/FeedKit)
```Bash
# Uncomment the next line to define a global platform for your project
 platform :ios, '11.0'

target 'TopMovies' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for TopMovies
  pod "FeedKit"
 ```
## 6.Run pop install to install the dependencies
```Bash
pod install
```
## 7.Copy the [Player.swift](https://github.com/piemonte/Player/tree/master/Sources) into your Xcode project 

## 8.Open the XCode workspace to launch the project
```Bash
open TopMovies.xcworkspace
```
