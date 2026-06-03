# Pokédex — Networked iOS App

Pokédex is a SwiftUI iOS app that connects to a RESTful API to fetch and display Pokémon data. The app includes user authentication, asynchronous networking, JSON decoding, searchable Pokémon lists, type-based sections, detail views, and capture/release functionality.

---

## Overview

The goal of this project was to practice core iOS networking concepts by building a Pokédex app that communicates with a local FastAPI server.

The app allows users to sign up, log in, view Pokémon data, search and filter Pokémon, view detailed Pokémon information, and capture or release Pokémon. The app also handles authentication state, API errors, loading states, and missing data from the API.

---

## Screenshots

### Login & Authentication


<img width="375" height="694" alt="login" src="https://github.com/user-attachments/assets/79f5e8d7-926d-460c-801e-ee919ea5fcd1" />

*Login screen with email/password authentication. The app authenticates against the FastAPI backend using JWT tokens and restores the session on launch.*

### Pokémon List

<img  width="375" height="694" alt="list" src="https://github.com/user-attachments/assets/9077bfe7-d3b7-4cd7-9991-196ea8e2f408" />


*Searchable Pokémon list fetched from the REST API, showing type tags, height, weight, and capture status for each entry.*

### Types View

<img width="375" height="694" alt="type" src="https://github.com/user-attachments/assets/7a87a164-a23c-4f37-ac46-ce6a09c8f7af" />

*Pokémon grouped into sections by type with a captured counter, demonstrating client-side organization of API data.*

---

## Features

- User sign up and login flow
- JWT-based authentication
- Token persistence using UserDefaults
- Pokémon list retrieval from a REST API
- Asynchronous networking using URLSession and Swift Concurrency
- JSON decoding into strongly typed Swift models using Codable
- Searchable and filterable Pokémon list
- Type-based Pokémon section view
- Account view with logged-in user information
- Detail view with Pokémon image, stats, types, weaknesses, and evolutions
- Capture and release functionality
- Pull-to-refresh support
- Light and dark mode support
- Graceful handling of missing data and image loading failures

---

## Tech Stack

| Technology       | Purpose                          |
|------------------|----------------------------------|
| Swift            | Primary language                 |
| SwiftUI          | UI framework                     |
| URLSession       | Networking                       |
| Swift Concurrency| Async/await network calls        |
| Codable          | JSON decoding                    |
| JWT              | Authentication                   |
| FastAPI          | Backend API (provided)           |

---

## How It Works

The app connects to a local FastAPI server that provides authentication and Pokémon data endpoints.

After a user logs in, the API returns a JWT token. The app stores the token locally and includes it in authorized requests. Pokémon data is fetched using asynchronous network requests and decoded into Swift models using Codable.

The UI updates based on the API response and authentication state. Users can browse Pokémon, search and filter results, navigate to detail views, and capture or release Pokémon. Changes are reflected across the app after the data is refreshed from the API.

---

## App Structure

The app is organized around a networking layer, authentication manager, models, and SwiftUI views.

```text
Models        → Pokémon models, authentication request/response models
Managers      → AuthManager and NetworkManager
Views         → Login, signup, list, type section, detail, and account screens
Networking    → API requests, JWT headers, response decoding, and error handling
```

---

## Main Screens

- Login / Sign Up
- Pokémon List View
- Sectioned Type View
- Pokémon Detail View
- Account View

---

## Networking

The app uses URLSession with async/await to communicate with the API.

The networking layer handles:
- Base URL configuration
- JSON request bodies
- Authorization headers
- JWT token usage
- GET and POST requests
- Response decoding
- Error handling for failed requests
- Handling invalid authentication responses such as HTTP 401

---

## Authentication

The app supports user authentication through the provided API, including:
- User signup
- User login
- JWT token storage
- Restoring login state on app launch
- Logging out and clearing saved credentials

---

## Pokémon Features

The app supports multiple ways to view Pokémon data.

**List View** — displays Pokémon in a vertical list. Each row can show name, image, height, weight, ID number, and capture status. Users can search and filter Pokémon by type or capture status.

**Type View** — organizes Pokémon into sections based on their types. Each section displays horizontally scrollable Pokémon cards.

**Detail View** — shows more information about a selected Pokémon, including name, large image, height, weight, types, weaknesses, previous evolutions, next evolutions, and a capture/release button.

---

## Project Status

, and I plan to continue improving it as a portfolio project.

---

## What I Learned

Through this project, I gained experience with SwiftUI networking, authentication state management, API integration, JSON decoding, error handling, and building reusable SwiftUI views.

I also learned how to structure a networked iOS app around a dedicated authentication manager and networking manager instead of placing API logic directly inside views.

---

## Future Improvements

- Add a demo GIF
- Improve UI polish and animations
- Add better empty-state and error-state screens
- Move token storage from UserDefaults to Keychain
- Add unit tests for networking and decoding logic
- Add more reusable components for list rows and cards
- Improve offline handling
- Add persistent user preferences
