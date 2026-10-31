# LookIn

A Flutter employee attendance and management UI prototype. The app includes a
dummy sign-in/sign-up flow, attendance dashboard, calendar history, request
submission, employee profile and settings, and a camera-based attendance screen.

## Run

```sh
flutter pub get
flutter run
```

Use any valid email and a password of at least six characters to enter the demo.
Data is currently local UI state and is not sent to a server.

## Camera / biometric integration

`BiometricCameraService` owns camera initialization and image capture. The
`CameraScreen.onImageCaptured` callback receives a `File`, providing a handoff
point for an ML model or backend integration. Face detection and identity
verification are not implemented in this UI prototype.

Camera access requires permission on the target device. Android and iOS usage
descriptions are included in their platform manifests.
