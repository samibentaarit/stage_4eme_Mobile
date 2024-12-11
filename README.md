Flutter Mobile App

Overview

This mobile app was developed during my internship to facilitate communication between school administrators, parents, and students. The app enables admins to send real-time updates and notifications about:

Attendance: Notify parents about their child’s attendance.

Announcements: Broadcast important announcements to all users.

The backend is built with NodeJs and the frontend for web is developed using React. The mobile app is powered by Flutter, utilizing Dart for a cross-platform solution.

Features

Admin Panel

Send notifications to parents and students.

Manage announcements with CRUD operations.

Track bus statuses in real-time.

Parent/Student Interface

Receive updates about attendance and transportation.

View detailed announcements and notifications.

Responsive and user-friendly interface.

Technology Stack

Mobile App

Flutter (Dart)

Push Notifications using Firebase Cloud Messaging (FCM).

Backend

nodejs

REST API endpoints.

Database integration with MongoDB.

Database

MongoDB for storing user data, announcements, and notifications.

Installation Guide

Prerequisites

Install Flutter and ensure it is added to your PATH.

Set up a compatible IDE (e.g., Android Studio, VS Code).

Ensure you have access to the backend API.

Steps

Clone the Repository

git clone https://github.com/samibentaarit/stage_4eme_Mobile.git
cd stage_4eme_Mobile

Install Dependencies
Run the following command to fetch the required dependencies:

flutter pub get

Set Up Configuration
Update the lib/config.dart file with the backend API URL and Firebase configuration.

Run the App

For Android:

flutter run --release

For iOS:

flutter run --release

Project Structure

lib/

main.dart: Entry point of the application.

screens/: Contains all the UI screens.

widgets/: Reusable custom widgets.

services/: API service calls.

models/: Data models for announcements, notifications, etc.

providers/: State management logic.

Contributing

Fork the repository.

Create a feature branch:

git checkout -b feature-name

Commit your changes:

git commit -m "Describe your changes"

Push to the branch:

git push origin feature-name

Open a pull request.

Future Enhancements

Add support for multiple languages.

Integrate analytics for user behavior.

Implement offline mode.

Contact

For any queries or feedback, please contact:

Name: Sami Bentaarit

Email: samibentaarit@example.com

GitHub: samibentaarit

