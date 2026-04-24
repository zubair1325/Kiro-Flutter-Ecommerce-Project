# 🛒 Kiro – Flutter eCommerce Application

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-Framework-02569B?style=for-the-badge\&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-Language-0175C2?style=for-the-badge\&logo=dart)
![Firebase](https://img.shields.io/badge/Firebase-Backend-FFCA28?style=for-the-badge\&logo=firebase)
![Firestore](https://img.shields.io/badge/Firestore-Database-FFA000?style=for-the-badge\&logo=firebase)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-green?style=for-the-badge)

### 🚀 Modern Multi-Role eCommerce Mobile Application Built with Flutter & Firebase

</div>

---

# 📑 Table of Contents

* [📌 Overview](#-overview)
* [✨ Key Features](#-key-features)
* [🔐 Authentication System](#-authentication-system)
* [👥 User Roles & Permissions](#-user-roles--permissions)
* [🏠 Home Screen Structure](#-home-screen-structure)
* [🧭 Navigation System](#-navigation-system)
* [📦 Product & Order Management](#-product--order-management)
* [🎨 UI/UX Design](#-uiux-design)
* [🛠️ Technologies Used](#️-technologies-used)
* [🏗️ System Architecture](#️-system-architecture)
* [🗄️ Database Structure](#️-database-structure)
* [🔒 Security Features](#-security-features)
* [📊 Benchmarking](#-benchmarking)
* [🚀 Future Improvements](#-future-improvements)
* [⭐ Advantages of the System](#-advantages-of-the-system)
* [⚙️ Installation Guide](#️-installation-guide)
* [📱 Application Screens](#-application-screens)
* [👨‍💻 Team Members](#-team-members)
* [📌 Conclusion](#-conclusion)

---

# 📌 Overview

## 📖 Introduction

**Kiro** is a modern and scalable **Flutter-based eCommerce mobile application** designed to provide a smooth and secure online shopping experience. The application combines **Customers, Sellers, and Admins** into a single ecosystem, allowing efficient product management, secure authentication, and seamless shopping operations.

The system is developed using:

* **Flutter** for frontend development
* **Firebase Authentication** for secure login & verification
* **Firebase Firestore** as realtime cloud database
* **Firebase Storage** for image and document storage

Kiro focuses on:

✅ Modern UI/UX
✅ Secure authentication
✅ Role-based access control
✅ Realtime database synchronization
✅ Scalable architecture
✅ Multi-role marketplace management

---

# ✨ Key Features

## 🛍️ Customer Features

* Browse products
* Search products
* View product details
* Add products to cart
* Add products to wishlist
* Place orders
* Download PDF invoices
* Update user profile
* Upload profile image
* Manage account settings

---

## 🏪 Seller Features

* Seller registration system
* Product management
* Product editing
* Stock management
* Discount management
* Advertisement request system
* Product listing control

---

## 🛡️ Admin Features

* Approve/reject seller requests
* Manage product categories
* Approve advertisements
* Monitor seller accounts
* Maintain platform integrity

---

# 🔐 Authentication System

The application uses **Firebase Authentication** to ensure secure user access and account management.

## 🔑 Authentication Features

* User Registration
* User Login
* Email Verification
* Mobile OTP Verification
* Password Reset
* Change Password
* Secure Session Management

---

## 🔄 Authentication Flow

```text
User Signup
     ↓
Email Verification
     ↓
Phone OTP Verification
     ↓
Authentication Success
     ↓
Role-Based Access Granted
```

---

# 👥 User Roles & Permissions

The application contains **three major user roles**.

---

## 👤 Customer

Customers are the primary users of the platform.

### ✅ Customer Capabilities

* Browse all products
* Search products
* Add products to cart
* Wishlist management
* Purchase products
* Download invoices
* Manage personal profile

---

### 🛒 Cart System

Features include:

* Multiple product support
* Quantity range: `1 - 99`
* Automatic price calculation
* Stock validation
* Checkout system

---

### ❤️ Wishlist System

Customers can save favorite products for future purchases.

---

## 🏪 Seller

Users can apply for seller access after completing verification.

### 📋 Seller Registration Requirements

* Verified email
* Verified phone number
* Unique store name
* NID document upload (PDF)

---

### 🔍 Seller Verification Process

```text
Seller Request
      ↓
Admin Review
      ↓
Approval / Rejection
      ↓
Seller Access Granted
```

---

### ✅ Seller Features

* Add products
* Edit products
* Manage stock
* Apply discounts
* Request homepage advertisements

---

## 🛡️ Admin

Admins maintain and control the system.

### ✅ Admin Responsibilities

* Seller approval management
* Category management
* Advertisement approval
* User monitoring
* System maintenance

---

# 🏠 Home Screen Structure

The home screen is designed to provide a modern and user-friendly shopping experience.

---

## 🖼️ 1. Image Slider

* Displays promotional banners
* Advertisement approval based
* Redirects to product details

---

## 📂 2. Categories Section

* Displays top categories
* Includes “See All” feature
* Category-wise product filtering

---

## 🛍️ 3. All Products Section

* Horizontal product listing
* “See All” navigation support

---

## 💸 4. Special Products Section

* Displays discounted products
* Sorted by highest discount

---

## 🔥 5. Popular Products Section

* Displays most purchased products
* Includes product ratings

---

## 🆕 6. New Products Section

* Shows recently added products

---

# 🧭 Navigation System

The application uses a **Bottom Navigation Bar** for easier accessibility.

## 📌 Navigation Items

| Icon | Section  |
| ---- | -------- |
| ❤️   | Wishlist |
| 📂   | Category |
| 🏠   | Home     |
| 🛒   | Cart     |
| ☰    | Menu     |

---

# 📋 Menu Section

The menu contains both static and dynamic options.

## 👤 Account Management

* Profile
* Change Password
* Seller Panel *(dynamic)*
* Admin Panel *(dynamic)*

---

## ℹ️ Additional Options

* About Kiro
* Help & Feedback
* About
* Sign Out

---

# 📦 Product & Order Management

---

## 📄 Product Details Page

The product details page contains:

* Product images
* Product description
* Price information
* Stock availability
* Product attributes
* Add to Cart button
* Wishlist button

---

# 🧾 Order System

The system supports complete order processing.

## ✅ Order Features

* Single product purchase
* Multiple product purchase
* Cart checkout
* Realtime stock validation
* Automatic order generation

---

# 🧾 Invoice System

## 📄 Invoice Features

* Auto-generated invoice
* PDF format support
* Downloadable invoice
* Order summary generation

---

# 🎨 UI/UX Design

The UI follows modern mobile application design principles.

---

## 🎯 Design Goals

* Simplicity
* Consistency
* Responsiveness
* User-friendly interaction
* Clean visual hierarchy

---

## 🎨 Application Theme

```dart
static const Color primaryColor = Color(0xFF07ADAE);
```

The application uses a **modern teal-based color palette** to create a professional and visually appealing interface.

---

# 🛠️ Technologies Used

---

## 📱 Frontend

* Flutter
* Dart

---

## ☁️ Backend & Cloud Services

* Firebase Authentication
* Firebase Firestore
* Firebase Storage

---

## 📦 Additional Packages

* PDF generation packages
* Image picker
* State management packages
* Firebase SDK packages

---

# 🏗️ System Architecture

The project follows a **cloud-based client-server architecture**.

---

## 🧩 Architecture Components

### 📱 Frontend Layer

Handles:

* UI rendering
* Navigation
* Business logic
* User interaction

---

### 🔐 Authentication Layer

Firebase Authentication handles:

* Login
* Signup
* OTP verification
* Email verification
* Password management

---

### 🗄️ Database Layer

Firestore manages:

* User data
* Product data
* Orders
* Wishlist
* Cart
* Seller information

---

### ☁️ Storage Layer

Firebase Storage manages:

* Product images
* User profile images
* Seller NID files

---

# 🗄️ Database Structure

## 📂 Collections Used

---

## 👤 users

Stores:

```text
Name
Email
Phone
Address
User Role
Profile Image
```

---

## 🛍️ products

Stores:

```text
Product Name
Price
Quantity
Category
Images
Discount
Seller ID
```

---

## 🏪 seller

Stores:

```text
Store Name
Verification Status
NID Link
Seller Account Status
```

---

## 📦 orders

Stores:

```text
Ordered Products
User ID
Total Amount
Timestamp
Order Status
```

---

## ❤️ wishlist

Stores customer favorite products.

---

## 🛒 cart

Stores cart products and quantities.

---

# 🔒 Security Features

The application implements multiple security mechanisms.

## 🛡️ Security Implementations

* Email verification
* Mobile OTP verification
* Role-based access control
* Firebase Authentication security
* Seller verification system
* Admin approval workflow
* Stock validation system

---

# 📊 Benchmarking

The system was benchmarked against modern eCommerce platforms such as:

* Amazon
* Daraz

---

## 📌 Comparison Areas

* Product browsing
* Cart management
* Authentication system
* Seller management
* Order processing
* User experience

---

Kiro focuses on implementing the core functionality of modern eCommerce platforms while maintaining simplicity and scalability.

---

# 🚀 Future Improvements

The project can be extended with advanced functionalities.

## 🔮 Planned Features

* Online payment gateway integration
* AI-based product recommendation system
* Real-time order tracking
* Customer-seller messaging system
* Multi-vendor marketplace expansion
* Advanced search & filtering
* Analytics dashboard
* Web application version
* Desktop support

---

# ⭐ Advantages of the System

## ✅ Benefits

* Realtime database synchronization
* Secure authentication system
* Role-based architecture
* Scalable cloud backend
* User-friendly interface
* Efficient product management
* Modular architecture for future expansion

---

# ⚙️ Installation Guide

## 📋 Requirements

* Flutter SDK
* Dart SDK
* Android Studio / VS Code
* Firebase Project
* Android Emulator or Physical Device

---

# 🚀 Setup Instructions

## 1️⃣ Clone Repository

```bash
git clone <repository_link>
```

---

## 2️⃣ Navigate to Project

```bash
cd kiro
```

---

## 3️⃣ Install Dependencies

```bash
flutter pub get
```

---

## 4️⃣ Configure Firebase

### Firebase Setup Steps

* Create Firebase Project
* Add Android/iOS applications
* Download Firebase configuration files
* Enable Firebase Authentication
* Enable Firestore Database
* Enable Firebase Storage

---

## 5️⃣ Run Application

```bash
flutter run
```

---

# 📱 Application Screens

## 🖥️ Included Screens

* Splash Screen
* Login Screen
* Signup Screen
* OTP Verification Screen
* Home Screen
* Category Screen
* Product List Screen
* Product Details Screen
* Cart Screen
* Wishlist Screen
* Checkout Screen
* Invoice Screen
* Profile Screen
* Seller Dashboard
* Admin Dashboard

---

# 👨‍💻 Team Members

Md. Zubair Rahman

---

# 📌 Conclusion

Kiro is a scalable and secure Flutter-based eCommerce solution that successfully integrates customers, sellers, and administrators into a unified platform.

The system demonstrates:

✅ Modern mobile application development
✅ Secure authentication workflows
✅ Realtime cloud database integration
✅ Role-based system architecture
✅ Efficient product & order management
✅ Expandable modular architecture

The project serves as a strong foundation for building advanced commercial eCommerce platforms in the future.

---

<div align="center">

## ⭐ If you like this project, consider giving it a star ⭐

</div>
