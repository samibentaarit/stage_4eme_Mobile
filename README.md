# Flutter Mobile App

## Overview
This mobile app was developed during my internship to facilitate communication between school administrators, parents, and students. The app enables admins to send real-time updates and notifications about:
- **Attendance**: Notify parents about their child’s attendance.
- **Announcements**: Broadcast important announcements to all users.

The backend is built with **Express.js** and the frontend for web is developed using **React**. The mobile app is powered by **Flutter**, utilizing **Dart** for a cross-platform solution.

---

## Features
### Admin Panel
- Send notifications to parents and students.
- Manage announcements with CRUD operations.

### Parent/Student Interface
- Receive updates about attendance .
- View detailed announcements and notifications.
- Responsive and user-friendly interface.

---

## Technology Stack
### Mobile App
- **Flutter** (Dart)
  - Widgets for UI development.
  - State management with Provider/Bloc.
  - Push Notifications using Firebase Cloud Messaging (FCM).

### Backend
- **Express.js**
  - REST API endpoints.
  - Database integration with MongoDB.

### Database
- **MongoDB** for storing user data, announcements, and notifications.

---

## Installation Guide

### Prerequisites
1. Install [Flutter](https://flutter.dev/docs/get-started/install) and ensure it is added to your PATH.
2. Set up a compatible IDE (e.g., Android Studio, VS Code).
3. Ensure you have access to the backend API.

### Steps
1. **Clone the Repository**
   ```bash
   git clone https://github.com/samibentaarit/stage_4eme_Mobile.git
   cd stage_4eme_Mobile
   ```
2. **Install Dependencies**
   Run the following command to fetch the required dependencies:
   ```bash
   flutter pub get
   ```
3. **Set Up Configuration**
   Update the `lib/config.dart` file with the backend API URL and Firebase configuration.

4. **Run the App**
   - For Android:
     ```bash
     flutter run --release
     ```
   - For iOS:
     ```bash
     flutter run --release
     ```

---

## Project Structure
- `lib/`
  - **main.dart**: Entry point of the application.
  - `screens/`: Contains all the UI screens.
  - `services/`: API service calls.
  - `models/`: Data models for announcements, notifications, etc.

---

## Future Enhancements
- Add support for multiple languages.
- Integrate analytics for user behavior.
- Implement offline mode.

---

## Contact
For any queries or feedback, please contact:
- **Name**: Sami Bentaarit
- **Email**: samibentaarit@example.com
- **GitHub**: [samibentaarit](https://github.com/samibentaarit)

