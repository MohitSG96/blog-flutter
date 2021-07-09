# blogs_app

A new Flutter Blogs Project.

## Getting Started

This project is a starting point for a Flutter application.

* Download APK https://drive.google.com/file/d/1GUMm9rx7x_xPAsLlnnm3sksvsadAjNUt/view?usp=sharing
* ### Setup flutter into system if not already
    1) https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_2.0.6-stable.zip (flutter downoad link)
    2) add flutter to your path https://flutter.dev/docs/get-started/install/windows#update-your-path
* setup editor here > https://flutter.dev/docs/get-started/editor
* to run add:

    1) ```flutter pub get```
    2) ```flutter run```
    

### Known Issue
#### Google sigin Issue caused since system's SHA key is for my account.
* Create firebase project and add android app (com.example.blog_app)
* Download google-services.json and replace it with project-location/android/app/google-services.json
* run 
    ```
    cd android
    gradlew siginReport
    ```
    and add SHA key into firebase project

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
