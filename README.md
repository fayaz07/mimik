<p align="center">
  <img src="https://github.com/fayaz07/mimik/blob/main/Mimik/Assets.xcassets/AppIcon.appiconset/mimik-256.png?raw=true"  />
</p>
<p align="center">🚧 Work in progress</p>
<h2 align="center">Mimik</h2>

An app that will help developers fasten their workflows, simpler for non-developers for changing content. 

**Change once reflect everywhere.** Wondering how? 

Think about an example of Translations, we use external CMS sites who want us to pay and have limits for content. 
This app will let you create translations required for your app at once and you can export for all platforms that you own,
for ex: you might have a mobile app for Android, one for iOS, one for Web each uses different ways to store translations
Android uses XML, iOS has Localize (key=value), most of the web uses JSON, this might be a headache for developers on large scale.
Consider a case where you need to remove duplicates, tough right? And think when your app supports 50 or 100 languages, complex right?
This app will use AI to generate translations, write in English and AI will take care of translating it to rest of the 100 languages, 
you can selectively filter where this translation might be used too, uncheck some of the apps to save memory and file size,
all that you can think of.

### Proposed Features

1. Translations
2. Constants
3. API calls

Want to propose more features? Become a contributor. You are always welcome.

### Proposed Architecture

> Note: Will add a clean arch diagram later

[Mimik macOS app](https://github.com/fayaz07/mimik) <- [Mimik Engine](https://github.com/fayaz07/libmimik) -> [Mimik Windows app](https://github.com/fayaz07/mimik-windows)

[Mimik Engine](https://github.com/fayaz07/libmimik) will act as a shared C++ library between different applications (macOS, Windows...) 
and will include all the common code that is required for the apps to run. 

I wanted the app to be fully offline, if you ask me why? I wanted the app to be free for all individuals, non-profit and non-commercial use 
while enterprises(except Thoughtworks), commericals can choose to pay and use the app or claim an exception or I might introduce a different app for them in future. (thinking too big, haha)

### Current Progress
1. **macOS:** Native SwiftUI app: Basic Setup is done with CoreData and Workspace page is added, waiting for [libmimik](https://github.com/fayaz07/libmimik)'s
   development on Supported Languages to initiate the Translations feature (I am new to swift and xcode)
2. **Windows:** Native Windows app: Initial commit
3. **libmimik:** Initially started with `GoLang`, later found that `cgo` support for later versions of GoLang after 1.23 was abandoned, now the project is setup
   to run on `C++`(again new to core C++).

### Plans
1. Hopeful to complete Translations feature in 3 months. Again it depends on my free time from work.
   
