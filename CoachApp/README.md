# Coach — AI Movement Analysis

Coach is an iOS movement analysis app that uses SwiftUI and Apple's Vision framework to detect body poses, track exercise movement, count reps, measure tempo, and provide real-time coaching feedback.

> Note: This project is currently in active development. Screenshots and demo media will be added when I have access to my development machine.

## Overview

The goal of Coach is to help users get real-time feedback during workouts. Instead of manually counting reps or reviewing form after a workout, the app uses the iPhone camera to analyze movement as the user exercises.

The app focuses on:

- Real-time pose detection
- Rep counting
- Movement-state tracking
- Tempo feedback
- Workout result visualization

## Features

- Real-time body pose detection using Apple's Vision framework
- Rep counting for supported exercises
- Exercise-agnostic state machine for tracking movement phases
- Hysteresis thresholds to reduce false rep counts
- Tempo tracking for movement speed analysis
- Audio coaching feedback during workouts
- Workout history and progress visualization using Apple Charts
- SwiftUI interface following MVVM architecture

## Tech Stack

- Swift
- SwiftUI
- Apple Vision
- AVFoundation
- Apple Charts
- MVVM Architecture

## How It Works

Coach uses the iPhone camera to capture live video frames. Apple's Vision framework detects human body landmarks from each frame. The app then analyzes joint positions and movement patterns to determine the user's exercise phase.

A state machine is used to track whether the user is in the starting position, lowering phase, bottom position, or rising phase of a movement. This helps prevent random motion or camera noise from being counted as extra reps.

Hysteresis thresholds are used to make the rep-counting logic more stable. A movement has to pass certain threshold values before the app changes states, which reduces false positives.

## Supported Exercises

- Squat
- Bench Press
- Deadlift

## Architecture

The app follows an MVVM structure:

```text
Views        → SwiftUI screens and camera UI
ViewModels   → Workout state, rep counting, and UI logic
Models       → Exercise data, rep data, and workout history
Services     → Pose detection, camera input, and audio feedback
```

## Project Status

Coach is currently under active development. The core focus is building stable real-time pose detection, rep counting logic, movement-state tracking, and workout feedback.

Screenshots and a demo GIF will be added soon.

## What I Learned

Through this project, I gained experience with real-time iOS development, body pose detection, state-based movement tracking, and building software around noisy camera and sensor data.

I also learned how to structure a larger SwiftUI app using MVVM and how to connect computer vision output to user-facing feedback.

## Future Improvements

- Add support for more exercises
- Improve form feedback beyond rep counting
- Add persistent workout history
- Add HealthKit support
- Add Apple Watch support
- Add more detailed charts for weekly progress and tempo trends
- Add demo video and screenshots
