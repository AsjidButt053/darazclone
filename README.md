# darazclone
Daraz Clone Using Flutter

# 🛍️ Daraz Clone - Flutter E-Commerce App

A full-featured mobile e-commerce application inspired by Daraz. Built using **Flutter** for the UI and **Firebase** for the backend, this project demonstrates a complete implementation of CRUD operations, state management, and real-time data handling.

> **Course Project:** Mobile Application Development
> **Status:** Active Development

## 📱 Project Overview

This application serves as a functional clone of a major e-commerce platform. It allows users to browse products, manage a cart, and perform administrative tasks. The primary goal of this project is to demonstrate the integration of a Flutter frontend with a serverless Firebase backend.

## ✨ Key Features

### User Features
* **Authentication:** Secure login and registration (Email/Password).
* **Product Browsing:** View product listings with images, prices, and descriptions.
* **Real-time Updates:** Product availability and details update instantly using Firebase Streams.
* **Cart Management:** Add to cart, remove items, and view total price calculations.
* **Responsive UI:** Optimized for both Mobile (Android/iOS) and Windows Desktop.

### Admin / Backend Features (CRUD)
* **Create:** Add new products with details and images.
* **Read:** Fetch and display product data from Cloud Firestore.
* **Update:** Edit existing product details (price, stock, description).
* **Delete:** Remove products from the listing.

## 🛠️ Tech Stack

* **Frontend:** [Flutter](https://flutter.dev/) (Dart)
* **Backend:** [Firebase](https://firebase.google.com/)
* **Database:** Cloud Firestore (NoSQL)
* **Authentication:** Firebase Auth
* **State Management:** Provider / GetX / Bloc (Update this based on what you used)

## 📸 Screenshots

| Home Screen | Product Details | Cart | Admin Panel |
|:---:|:---:|:---:|:---:|
| <img src="assets/screenshots/home.png" width="200"> | <img src="assets/screenshots/detail.png" width="200"> | <img src="assets/screenshots/cart.png" width="200"> | <img src="assets/screenshots/admin.png" width="200"> |

*(Note: Upload screenshots to an `assets/screenshots` folder in your repo to make these appear).*

## 🚀 Getting Started

### Prerequisites
* Flutter SDK installed.
* A Firebase Project set up with Firestore enabled.

### Installation

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/yourusername/daraz-clone.git](https://github.com/yourusername/daraz-clone.git)
    cd daraz-clone
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Firebase Setup:**
    * Create a project on the [Firebase Console](https://console.firebase.google.com/).
    * Download `google-services.json` (for Android) and `GoogleService-Info.plist` (for iOS).
    * Place them in the respective `android/app` and `ios/Runner` directories.
    * *Note: For Windows support, ensure `firebase_core` is configured for desktop.*

4.  **Run the App:**
    ```bash
    flutter run
    ```

## 🤝 Contributing

Contributions are welcome! If you have suggestions for improving the UI or adding new features (like a payment gateway), feel free to fork the repo and submit a pull request.

## 📄 License

This project is for educational purposes.
