# React Native Audio Pro

Modern, background-capable audio playback for React Native — built for podcasts, audiobooks, live streams, and long-form media. Works out of the box with background playback, lock screen controls, and clean hooks-based state. Under the hood: Android uses Media3 (not old-school ExoPlayer), giving you up-to-date media session support without any of the legacy baggage. iOS uses AVFoundation, Apple's native audio engine for professional-grade media playback. Web uses the HTML5 Audio API for cross-browser compatibility. Supports static remote files, live streaming URLs, and local files (for both audio and artwork) across all platforms.

[![npm version](https://img.shields.io/npm/v/react-native-audio-pro?logo=npm&logoColor=white&labelColor=grey&color=blue)](https://www.npmjs.com/package/react-native-audio-pro)
[![website](https://img.shields.io/badge/website-rnap.dev-grey?logo=google-chrome&logoColor=white&color=blue)](https://rnap.dev)
[![GitHub](https://img.shields.io/badge/evergrace--co-react--native--audio--pro-grey?logo=github&logoColor=white&labelColor=grey&color=blue)](https://github.com/evergrace-co/react-native-audio-pro)

## Table of Contents

- [⚙️ Requirements](#-requirements)
- [🚀 Installation](#-installation)
- [📚 API Overview](#api-overview)
- [⚡️ useAudioPro Hook Example](#useaudiopro-hook-example)
- [📦 API Usage Example](#api-usage-example)
- [📱 Example App](#-example-app)
- [🤝 Contributing](#contributing)
- [🪪 License](#license)

## ⚙️ Requirements

- **TypeScript:** 5.0 or higher
- **React Native:** 0.72 or higher
- **iOS:** iOS 15.1 or higher
- **Android:** Android 7.0 (API 26) or higher (tested on API 28+)

## 🚀 Installation

```bash
npm install react-native-audio-pro
```
or
```bash
yarn add react-native-audio-pro
```

### 🍎 iOS Installation

Install the CocoaPods dependencies:
```bash
npx pod-install
```

#### Enable Background Modes

1. Open your project settings in Xcode.
2. Go to **Signing & Capabilities**.
3. Add **Background Modes** and enable **Audio, AirPlay, and Picture in Picture**.

### 🤖 Android Installation

> **Note:** This library requires Android 7.0 (API 26)+ and `compileSdkVersion = 35` and `targetSdkVersion = 35` to support the latest Media3 features. While Media3 APIs are supported from API 21+, testing is focused on API 28+.

#### Gradle Configuration

In `android/build.gradle`:

```gradle
buildscript {
    ext {
        minSdkVersion = 26
        compileSdkVersion = 35
        targetSdkVersion = 35
        // ...
    }
}
```

## 📚 API Overview

React Native Audio Pro supports various audio formats including MP3, AAC, WAV, and streaming protocols like HLS, DASH, RTSP, and RTMP.

### 🛠 Methods

- **play(track: AudioProTrack, options?: AudioProPlayOptions)**
  - Loads and starts playing the specified track in one step.
  - `options` is an object with the following properties:
    - `autoPlay?: boolean` - When `false`, prepares the player without starting playback (default: `true`).
    - `headers?: { audio?: Record<string, string>, artwork?: Record<string, string> }` - Custom HTTP headers for audio and artwork requests.
- **pause()**
  - Pauses the current playback.
- **resume()**
  - Resumes playback if paused.
- **stop()**
  - Stops the playback, resetting to position 0 and clearing the playing track.
- **seekTo(positionMs: number)**
  - Seeks to a specific position (in milliseconds).
- **seekForward(amountMs?: number)**
  - Seeks forward by specified milliseconds (default: 30 seconds).
- **seekBack(amountMs?: number)**
  - Seeks backward by specified milliseconds (default: 30 seconds).
- **configure(options: AudioProSetupOptions)**
  - Optional. Sets playback options like content type (`'MUSIC'` or `'SPEECH'`). Takes effect the next time `play()` is called.
- **getTimings(): { position: number, duration: number }**
  - Returns the current playback position and total duration in milliseconds.
- **getState(): AudioProState**
  - Returns the current playback state (STOPPED, LOADING, PLAYING, PAUSED, ERROR).
- **getPlayingTrack(): AudioProTrack | null**
  - Returns the currently playing track, or null if no track is playing.
- **setPlaybackSpeed(speed: number)**
  - Sets the playback speed rate (0.25 to 2.0). Normal speed is 1.0.
- **getPlaybackSpeed(): number**
  - Returns the current playback speed rate.
- **getError(): AudioProPlaybackErrorPayload | null**
  - Returns the last error that occurred, or null if no error has occurred.

### 🎧 Event Listeners

- **addEventListener(callback: AudioProEventCallback): EmitterSubscription**
  - Listens for playback events (e.g., state changes, track ended, errors, progress).

### 🧱 Enums

- **AudioProState:** `STOPPED`, `LOADING`, `PLAYING`, `PAUSED`, `ERROR`
- **AudioProEventType:** `STATE_CHANGED`, `TRACK_ENDED`, `PLAYBACK_ERROR`, `PROGRESS`, `SEEK_COMPLETE`, `REMOTE_NEXT`, `REMOTE_PREV`, `PLAYBACK_SPEED_CHANGED`
- **AudioProContentType:** `MUSIC`, `SPEECH`

### Lock Screen Controls

Both iOS and Android support lock screen and notification controls for play/pause, seek, and track navigation (next/previous).

### 🧩 Types

<details>
<summary><b>Track and Configuration Types</b></summary>

```typescript
type AudioProTrack = {
    id: string;
    url: string | number; // the media url (mp3, m4a, streaming URLs) or local asset via require()
    title: string;
    artwork: string | number; // the image url (jpg, png), or local asset via require()
    album?: string;
    artist?: string;
};

type AudioProSetupOptions = {
    contentType?: AudioProContentType; // MUSIC or SPEECH
    debug?: boolean; // Verbose logging
    debugIncludesProgress?: boolean; // Whether to include progress events in debug logs (default: false)
};
```
</details>

<details>
<summary><b>Event Types</b></summary>

```typescript
// Unified event structure
interface AudioProEvent {
    type: AudioProEventType;
    track: AudioProTrack | null; // Required for all events except REMOTE_NEXT and REMOTE_PREV
    payload?: {
        state?: AudioProState;
        position?: number;
        duration?: number;
        error?: string;
        errorCode?: number;
        speed?: number;
    };
}

// Note: Command events (REMOTE_NEXT, REMOTE_PREV) don't update state and don't require track information.
// All other events must include track to ensure state consistency.

// Event payload examples
interface AudioProStateChangedPayload {
    state: AudioProState;
    position: number;
    duration: number;
}

interface AudioProTrackEndedPayload {
    position: number;
    duration: number;
}

interface AudioProPlaybackErrorPayload {
    error: string;
    errorCode?: number;
}

interface AudioProPlaybackSpeedChangedPayload {
    speed: number;
}
```
</details>

<details>
<summary><b>About contentType</b></summary>

Use `AudioProContentType.SPEECH` for podcasts or audiobooks, `AudioProContentType.MUSIC` for songs or music-heavy audio. This optimizes playback behavior like audio focus and routing. Defaults to `AudioProContentType.MUSIC`.
</details>

<details>
<summary><b>About debug options</b></summary>

- `debug`: When set to `true`, enables verbose logging of all audio events. Useful for development and troubleshooting.
- `debugIncludesProgress`: When set to `true`, includes PROGRESS events in debug logs. PROGRESS events occur every second during playback and can flood the logs, making it harder to see other important events. Defaults to `false`.
</details>

### Handling Remote Events

To handle next and previous track events from lock screen controls:

```typescript
import { AudioPro, AudioProEventType } from 'react-native-audio-pro';

// Set up listeners outside React components (see warning section below)
const subscription = AudioPro.addEventListener((event) => {
  switch (event.type) {
    case AudioProEventType.REMOTE_NEXT:
      // Handle next track button press
      console.log('User pressed Next button');
      // Load and play next track
      break;

    case AudioProEventType.REMOTE_PREV:
      // Handle previous track button press
      console.log('User pressed Previous button');
      // Load and play previous track
      break;

    case AudioProEventType.STATE_CHANGED:
      // Handle state changes
      console.log('State changed to:', event.payload?.state);
      break;
  }
});

// Later, when you want to remove the listener
subscription.remove();
```

## ⚡️ useAudioPro Hook Example

The `useAudioPro` hook gives you real-time access to the playback state, current position, total duration, and the currently playing track via the `playingTrack` property.

```typescript jsx
import { useAudioPro } from 'react-native-audio-pro';

const AudioStatus = () => {
  const { state, position, duration, playingTrack, playbackSpeed, error } = useAudioPro();

  return (
    <View>
      <Text>Playback State: {state}</Text>
      <Text>Current Position: {position}ms</Text>
      <Text>Total Duration: {duration}ms</Text>
      <Text>Playback Speed: {playbackSpeed}x</Text>
      {error && (
        <View style={{ backgroundColor: '#ffeeee', padding: 10, borderRadius: 5 }}>
          <Text style={{ color: 'red' }}>Error: {error.error}</Text>
          <Text style={{ color: 'red' }}>Code: {error.errorCode}</Text>
        </View>
      )}
      {playingTrack && (
        <View>
          <Text>Track ID: {playingTrack.id}</Text>
          <Text>Now Playing: {playingTrack.title}</Text>
          <Text>Artist: {playingTrack.artist}</Text>
        </View>
      )}
    </View>
  );
};

export default AudioStatus;
```

## 📦 API Usage Example

```typescript
import { AudioPro, AudioProContentType } from 'react-native-audio-pro';

// Optional: Set playback config
AudioPro.configure({
  contentType: AudioProContentType.MUSIC,
  debug: __DEV__,
  debugIncludesProgress: false // Set to true to include progress events in debug logs
});

// Define an audio track (supports static remote files, live streams, and local files)
const track = {
  id: 'track-001',
  url: 'https://example.com/audio.mp3', // Remote file, live stream URL, or local file via require()
  title: 'My Track',
  artwork: 'https://example.com/artwork.jpg', // Remote image or local image via require()
  artist: 'Artist Name',
};

// Load and play the track
AudioPro.play(track);

// Or load without auto-playing (prepare only)
AudioPro.play(track, { autoPlay: false });

// Control playback
AudioPro.pause();
AudioPro.resume();
AudioPro.seekTo(60);

// Adjust playback speed (1.0 is normal speed)
AudioPro.setPlaybackSpeed(1.5); // 1.5x speed for faster playback
AudioPro.setPlaybackSpeed(0.8); // 0.8x speed for slower playback

// Get current state without using the hook
const { position, duration } = AudioPro.getTimings();
const state = AudioPro.getState();
const playingTrack = AudioPro.getPlayingTrack();
const speed = AudioPro.getPlaybackSpeed();
const error = AudioPro.getError();
console.log(`Currently playing: ${playingTrack?.title} (${position}/${duration}ms) - State: ${state} - Speed: ${speed}x`);
```

## ⚠️ Important: Event Listeners and React Lifecycle

When React Native apps go to the background, React may unmount your components or even your entire app. To ensure continuous audio playback and event handling, **always set up audio event listeners outside the React component lifecycle**.

### Example Setup Pattern

```javascript
// index.js - App Entry Point
import { AppRegistry } from 'react-native';
import App from './App';
import { name as appName } from './app.json';
import { setupAudio } from './audioSetup';

// Register the React component
AppRegistry.registerComponent(appName, () => App);

// Initialize audio logic OUTSIDE of React lifecycle
setupAudio();
```

```javascript
// audioSetup.js example
import { AudioPro, AudioProEventType, AudioProContentType } from 'react-native-audio-pro';

export function setupAudio() {
  // Configure audio settings
  AudioPro.configure({
    contentType: AudioProContentType.MUSIC,
    debug: __DEV__,
    debugIncludesProgress: false // Set to true to include progress events in debug logs
  });

  // Set up event listeners that persist for the app's lifetime
  AudioPro.addEventListener((event) => {
    switch (event.type) {
      case AudioProEventType.TRACK_ENDED:
        // Auto-play next track when current track ends
        const nextTrack = determineNextTrack();
        if (nextTrack) {
          AudioPro.play(nextTrack);
        }
        break;

      case AudioProEventType.REMOTE_NEXT:
        // Handle next button press from lock screen/notification
        const nextTrackFromRemote = determineNextTrack();
        AudioPro.play(nextTrackFromRemote);
        break;
    }
  });
}

function determineNextTrack() { /* Your logic here */ }
```

## 📱 Example App

<details>
<summary><b>Running the Example App</b></summary>

A complete working example for iOS and Android is provided in the [`example/`](./example) folder.

It demonstrates how to use `react-native-audio-pro` in a real React Native app, including:

- Track metadata (title, artist, artwork)
- Play/Pause/Seek/Skip controls
- Progress slider
- Event listeners set up outside the React lifecycle

### To run the example:

* Clone this repo and run the below commands

```bash
yarn install
yarn example start
```
And in a new terminal window/pane:

```bash
yarn example ios
# or
yarn example android
```

**OR** open the `./example/ios` folder in XCode, or the `./example/android` folder in Android Studio and run the app on a simulator or physical device.
</details>

## 🌐 Web Support

<details>
<summary><b>Web Platform Information</b></summary>

This library supports web environments through react-native-web. The API is identical to the native version.

### Web Limitations

- Lock screen controls are not available on web platforms
- Some streaming protocols may have limited support depending on the browser
- Autoplay policies may require user interaction before playback can begin
- Supported audio formats depend on the browser (MP3, AAC, WAV, Ogg, Opus, WebM are generally well-supported)

### Running the Web Example

To run the included web example:

```bash
yarn example web
```
</details>

---

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)
