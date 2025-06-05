# Asahi

Asahi is an iOS client for interacting with the **Automatic1111** Stable Diffusion web UI API. It allows you to connect to a remote server and generate images from text prompts directly on your device.

## Features

- Generate images using your configured Stable Diffusion server
- View generation history and reuse previous settings
- Basic server health checks

## Building

Open `Asahi.xcodeproj` with Xcode 15 or later and build the `Asahi` target. A running instance of the Automatic1111 web UI is required for generating images.
## Project Structure

Source code resides in `Sources/` with the following directories:
- `App` for the main entry point
- `Models` for data objects
- `ViewModels` for app state logic
- `Views` for SwiftUI screens
- `Services` for network code
- `Extensions` for helpers

Assets and preview resources live under `Resources/`.


## License

This project is released under the MIT license. See [LICENSE](LICENSE) for details.

