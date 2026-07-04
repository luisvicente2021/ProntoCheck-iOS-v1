# 🕒 ProntoCheck

A native iOS attendance management application built with **Swift** and **SwiftUI**. ProntoCheck automates employee clock-in and clock-out by combining **GPS geofencing** and **camera verification**, ensuring attendance is recorded only from authorized locations.

---

## ✨ Features

* 👥 Employee Management (Create, Edit, Delete)
* 📍 GPS validation with geofencing
* 📷 Camera integration for attendance verification
* 🕒 Clock In / Clock Out
* 📋 Attendance history
* 🌐 REST API integration
* 🔐 Secure authentication
* 📱 Native iOS experience

---

## 🏗️ Architecture

This project follows the **MVVM (Model–View–ViewModel)** architecture to promote scalability, maintainability, and separation of concerns.

```text
Presentation
│
├── Views
├── ViewModels
│
Domain
│
├── Models
├── Repositories
│
Data
│
├── Network
├── Services
└── API
```

---

## 🛠️ Tech Stack

| Technology   | Description           |
| ------------ | --------------------- |
| Swift        | Programming Language  |
| SwiftUI      | User Interface        |
| CoreLocation | GPS & Geofencing      |
| AVFoundation | Camera Access         |
| URLSession   | Networking            |
| REST API     | Backend Communication |
| MVVM         | Architecture Pattern  |
| Git & GitHub | Version Control       |

---

## 📁 Project Structure

```text
ProntoCheck
│
├── App
├── Core
│   ├── Extensions
│   ├── FaceRecognition
│   ├── Location
│   ├── Network
│   └── State
│
├── Features
│   ├── AdminLogin
│   ├── Asistencia
│   ├── Empleados
│   ├── PuntosAcceso
│   └── Reloj
│
├── Resources
└── Preview Content
```

---

## 📸 Screenshots

|           Employee Registration           |         Attendance Clock         |
| :---------------------------------------: | :------------------------------: |
| ![](screenshots/employee_onboarding.jpeg) | ![](screenshots/time_clock.jpeg) |

|       Employee Management       |
| :-----------------------------: |
| ![](screenshots/employees.jpeg) |

---

## 🚀 Getting Started

Clone the repository:

```bash
git clone git@github.com:luisvicente2021/ProntoCheck-iOS.git
```

Open the project:

```bash
open ProntoCheck.xcodeproj
```

Run the application using **Xcode** and grant **Camera** and **Location** permissions when prompted.

---

## 📋 Requirements

* macOS
* Xcode
* iOS Simulator or Physical Device
* Swift

---

## 🔮 Roadmap

* [x] Employee Management
* [x] GPS Validation
* [x] Camera Integration
* [x] Attendance Registration
* [ ] Face Recognition
* [ ] Push Notifications
* [ ] Offline Mode
* [ ] Unit Tests
* [ ] CI/CD Pipeline

---

## 👨‍💻 Author

**Luis Ángel Robles**

iOS Developer

GitHub: https://github.com/luisvicente2021

---

## 📄 License

This project was developed for educational and portfolio purposes.

