# Coach — AI Movement Analysis

Coach is an iOS movement analysis app that uses SwiftUI and Apple's Vision framework to detect body poses, track exercise movement, count reps, measure tempo, and provide real-time coaching feedback.

---

## Overview

The goal of Coach is to help users get real-time feedback during workouts. Instead of manually counting reps or reviewing form after a workout, the app uses the iPhone camera to analyze movement as the user exercises.

The app focuses on:
- Real-time pose detection
- Rep counting
- Movement-state tracking
- Tempo feedback
- Workout result visualization

---

## Screenshots

### Rep Counter

<img width="278" alt="Rep counter" src="https://github.com/user-attachments/assets/439c8e8a-958a-447f-858c-72c5b3e22b9f" />

*Live workout screen showing real-time hip angle tracking, rep counter, and movement state during a deadlift.*

### Workout Results

<img width="278" alt="Workout results" src="https://github.com/user-attachments/assets/824f15a5-4a52-40e3-8890-071a41c11d89" />

*Post-workout summary showing total reps completed along with average, fastest, and slowest tempo, plus automated coaching notes.*

### Workout History

<img width="278" alt="Workout history" src="https://github.com/user-attachments/assets/76fdb0f5-6af3-47d3-b295-493581a47262" />

*Weekly workout history showing exercise sessions, rep counts, and average tempo tracked across the week.*

---

## Features

- Real-time body pose detection using Apple's Vision framework
- Rep counting for supported exercises
- Exercise-agnostic state machine for tracking movement phases
- Hysteresis thresholds to reduce false rep counts
- Tempo tracking for movement speed analysis
- Audio coaching feedback during workouts
- Workout history and progress visualization using Apple Charts
- SwiftUI interface following MVVM architecture

---

## Tech Stack

| Technology   | Purpose               |
|--------------|-----------------------|
| Swift        | Primary language      |
| SwiftUI      | UI framework          |
| Apple Vision | Body pose detection   |
| AVFoundation | Camera input          |
| Apple Charts | Workout visualization |
| MVVM         | Architecture pattern  |

---

## How It Works

Coach uses the iPhone camera to capture live video frames. Apple's Vision framework detects human body landmarks from each frame. The app then analyzes joint positions and movement patterns to determine the user's exercise phase.

A state machine tracks whether the user is in the starting position, lowering phase, bottom position, or rising phase. This prevents random motion or camera noise from being counted as extra reps.

Hysteresis thresholds make the rep-counting logic more stable. A movement must pass certain threshold values before the app changes states, reducing false positives.

*Pose detection is powered by Apple's Vision framework. See [Apple's Human Body Pose documentation](https://developer.apple.com/documentation/vision/detecting_human_body_poses_in_images) for reference.*

---

## Supported Exercises

- Squat
- Bench Press
- Deadlift

---

## Architecture

The app follows an MVVM structure:

```text
Views        → SwiftUI screens and camera UI
ViewModels   → Workout state, rep counting, and UI logic
Models       → Exercise data, rep data, and workout history
Services     → Pose detection, camera input, and audio feedback
```

---

## Project Status

Coach is currently under active development. The core focus is building stable real-time pose detection, rep counting logic, movement-state tracking, and workout feedback.

---

## What I Learned

Through this project, I gained experience with real-time iOS development, body pose detection, state-based movement tracking, and building software around noisy camera and sensor data.

I also learned how to structure a larger SwiftUI app using MVVM and how to connect computer vision output to user-facing feedback.

---

## Future Improvements

- Add support for more exercises
- Improve form feedback beyond rep counting
- Add persistent workout history
- Add HealthKit support
- Add Apple Watch support
- Add more detailed charts for weekly progress and tempo trends
- Add demo video
