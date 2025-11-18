# TaskFlow - Offline-First Task Management App
## 👤  Oluwatunmise Dunmade

A Flutter task management application built with offline-first architecture, adaptive theming, and biometric authentication.

## 📱 Features

### Core Features
- ✅ **Create, Read, Update, Delete (CRUD)** tasks with rich details
- ✅ **Offline-First Architecture** - App works fully without internet
- ✅ **Local Data Persistence** using Hive database
- ✅ **Task Statistics** - View completion metrics and category breakdowns
- ✅ **Pull-to-Refresh** - Manual sync with API (demo purposes)
- ✅ **Connectivity Status** - Real-time online/offline indicator
- ✅ **Biometric Authentication** - Face ID/Fingerprint support with graceful fallback
- ✅ **Infinite Scroll Pagination** - Smooth scrolling with lazy loading
- ✅ **Adaptive Theme** - Light and Dark mode with persistent user preference
- ✅ **Animated UI Components** - Smooth transitions and interactive animations
- ✅ **Form Validation** - Real-time input validation for task creation/editing
- ✅ **Hero Animations** - Smooth screen transitions with shared element animations
- ✅ **Search & Filter** - Search by title, filter by status (All/Completed/Pending)
- ✅ **Category System** - Organize tasks with Work, Personal, Shopping, Health, and Other categories
- ✅ **Sort Options** - Sort by Date Created, Due Date, or Title

## 🏗️ Architecture & Design Decisions

### State Management
**Solution Used: Stacked (MVVM Pattern)**

**Why Stacked?**
- Clean separation of concerns with ViewModels and Views
- Built-in dependency injection with `get_it`
- Reactive state management with `notifyListeners()/rebuildUi()`
- Easy navigation and dialog/bottom sheet management
- Excellent for scalable, maintainable architecture

**Architecture Pattern: MVVM (Model-View-ViewModel)**
```
lib/
├── models/           # Data models (Task, Category, Enums)
├── services/         # Business logic (API, Storage, Biometrics)
├── repositories/     # Data layer abstraction
├── viewmodels/       # State management & business logic
├── ui/
│   ├── screens/      # View layer
│   ├── common/       # Reusable UI components
│   └── bottom_sheets/ # Modal bottom sheets
└── helpers/          # Utilities (API client, error handling)
```

### Offline-First Architecture

**Core Principle:** Local storage is the single source of truth.

**How It Works:**
1. All CRUD operations save to local Hive database first
2. Changes are immediately reflected in the UI
3. API calls happen in the background (non-blocking)
4. If API fails, the app continues working seamlessly
5. User never experiences downtime or data loss

**Benefits:**
- ✅ Instant UI updates
- ✅ Works without internet
- ✅ No loading spinners for local operations
- ✅ Better user experience

**Implementation Note:** For demo purposes, API responses are intentionally NOT merged with local storage to showcase the offline-first approach. 

### Data Persistence
**Hive Database**
- Fast, lightweight local storage
- Type-safe with code generation
- Stores tasks with full CRUD support

### API Integration
**JSONPlaceholder (Demo API)**
- Demonstrates CRUD capability
- Shows network error handling
- API calls don't affect local data (by design)
- Background sync for better UX

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.5.0)
- Dart SDK (>=3.5.0)
- iOS Simulator / Android Emulator / Physical Device
- Xcode (for iOS development)
- Android Studio (for Android development)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd taskflow
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code (for Hive, Stacked, Freezed)**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Platform-Specific Setup

#### iOS (for Biometric Authentication)
The app uses Face ID/Touch ID. Permissions are already configured in `ios/Runner/Info.plist`:
```xml
<key>NSFaceIDUsageDescription</key>
<string>TaskFlow uses biometric authentication to securely access your tasks</string>
```

#### Android (for Biometric Authentication)
Biometric permissions are configured in `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.USE_BIOMETRIC"/>
```

The `MainActivity` uses `FlutterFragmentActivity` for biometric support.

## 📦 Key Dependencies

| Package | Purpose |
|---------|---------|
| `stacked` | MVVM state management |
| `hive_ce_flutter` | Local NoSQL database |
| `infinite_scroll_pagination` | Pagination implementation |
| `local_auth` | Biometric authentication |
| `adaptive_theme` | Light/Dark theme management |
| `dio` | HTTP client for API calls |
| `logger` | Structured logging |
| `internet_connection_checker_plus` | Connectivity monitoring |
| `toastification` | Toast notifications |
| `font_awesome_flutter` | Icon library |
| `google_fonts` | Custom typography |
| `freezed` | Immutable models |

## 🎨 Design Patterns Used

1. **Repository Pattern** - Abstracts data sources (API + Local Storage)
2. **Dependency Injection** - Using `get_it` for service locator pattern
3. **Factory Pattern** - For creating complex objects
4. **Observer Pattern** - Via `notifyListeners()/rebuildUi()` in ViewModels
5. **Singleton Pattern** - For services like `StorageService`, `BiometricsService`

## ⚖️ Trade-offs & Decisions

### Due to Time Constraints

1. **Simplified Sync Logic**
   - **Decision:** API responses don't merge with local data
   - **Trade-off:** Demonstrates offline-first 


2. **Basic Search Implementation**
   - **Decision:** Simple in-memory filtering
   - **Trade-off:** Works well for small datasets but may be slow with 10k+ tasks


3. **Date Handling**
   - **Decision:** Built custom date comparison logic for "Today/Yesterday" labels
   - **Trade-off:** Custom code instead of using a library like `jiffy` or `timeago`
   - **Reason:** Needed calendar-day precision (yesterday = previous calendar day, not "24 hours ago")
   - **Example:** Task created at 11:59 PM shows "yesterday" at 12:01 AM (new day), not "2 minutes ago"

4. **Limited Task Fields**
   - **Decision:** Basic task model (title, description, category, due date, status)
   - **Trade-off:** Could add priority, tags, attachments, reminders
   - **Reason:** Focused on core functionality and architecture

5. **No User Authentication**
   - **Decision:** Single-user app with biometric lock
   - **Trade-off:** No multi-user support or cloud backup
   - **Reason:** Simplified scope; biometrics demonstrate security awareness

6. **Client-Side Pagination**
   - **Decision:** Implemented pagination with local data (infinite scroll)
   - **Trade-off:** Not server-side pagination; loads all data then paginates in-memory
   - **Reason:** JSONPlaceholder doesn't support pagination; demonstrates the pattern for future API integration

## ✨ Features from Part 5 Implemented

### 1. Search & Filter
- ✅ Search tasks by title (with debouncing)
- ✅ Filter by status (all/completed/pending)
- ✅ Sort by date created, due date, or title (alphabetically)
- ✅ Category-based filtering

### 2. Custom Animations
- ✅ Animated task completion (checkbox animation using `msh_checkbox`)
- ✅ Hero animation when navigating to detail screen
- ✅ Smooth list item insertion/deletion
- ✅ Pull-to-refresh animation with custom indicator
- ✅ Skeleton loading animations

### 3. Dark Mode
- ✅ Toggle between light and dark themes
- ✅ Persist theme preference (survives app restart)
- ✅ Smooth theme transition using `adaptive_theme` package
- ✅ Theme icon in app bar for easy access

### 4. Form Validation
- ✅ Validate task title (required, minimum 3 characters)
- ✅ Show real-time error messages
- ✅ Disable save button until form is valid
- ✅ Due date validation (must be in future)
- ✅ Visual feedback for validation states

### 5. Performance Optimization
- ✅ Implement lazy loading with infinite scroll pagination
- ✅ Use const constructors throughout the app
- ✅ Efficient state management (only notify when needed)
- ✅ Background API calls (non-blocking UI)
- ✅ Debounced search to reduce operations

## 🐛 Known Issues & Limitations

### Known Issues
1. **Background Sync Timing**
   - Background API calls happen on app launch and after operations
   - I could've used `WorkManager` for scheduled syncs

2. **Date Picker on iOS**
   - Using Syncfusion date picker for consistency
   - I could've replaced with native picker for better iOS integration

3. **Pagination Reset**
   - Pagination controller resets on filter/sort/search changes
   - Expected behavior but could cache previous pages for faster back navigation

### Limitations
1. **No Cloud Backup**
   - Data stored only locally
   - Lost if app is uninstalled or device is reset

2. **No Push Notifications**
   - No task reminders or due date notifications

3. **Limited Conflict Resolution**
   - No handling for sync conflicts between devices


4. **No Task Sharing**
   - Single-user app with no collaboration features


5. **Basic Analytics**
   - Simple statistics; no advanced insights


## 🧪 Testing

### To Run Tests
```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test/

# Coverage report
flutter test --coverage
```

**Note:** Test coverage is minimal due to time constraints. In production, would include:
- Unit tests for ViewModels
- Repository tests with mocked services
- Widget tests for UI components
- Integration tests for critical user flows

## 📱 App Flow

1. **Splash Screen** → Checks biometric availability
2. **Biometric Screen** → Optional authentication (skippable)
3. **Home Screen** → Main task list with filters/search
4. **Task Details Screen** → Create/Edit tasks
5. **Statistics Screen** → View task metrics


## 🔐 Security Considerations

1. **Biometric Authentication** - Optional but recommended
2. **Local Data Encryption** - Not implemented (Hive supports encryption)
3. **API Keys** - Stored in `.env` file (not committed to repo)
4. **Input Validation** - All user inputs validated


