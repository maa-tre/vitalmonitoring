# IoT Based Vital Monitoring System

A comprehensive Flutter application for real-time health monitoring of patients by doctors. This system is built for your final year project and provides multi-platform support.

## Features

### 🎯 Core Features

1. **Splash Screen**
   - Professional intro animation with medical icon
   - 5-second display duration
   - Smooth fade-in effect

2. **Authentication System**
   - Dual-role login (Patient & Doctor)
   - Role-based dashboard navigation
   - Secure login interface

3. **Patient Dashboard**
   - Real-time vital signs display
   - AQI (Air Quality Index) monitoring
   - Body temperature tracking
   - Room temperature monitoring
   - Heart rate display
   - ECG (Electrocardiogram) chart visualization
   - Personal information display

4. **Doctor Dashboard**
   - Multi-patient monitoring
   - Real-time vital signs for all patients
   - Patient status color-coding
   - Expandable patient cards with detailed information
   - Send alerts to patients
   - View individual patient ECG charts
   - Summary statistics (total patients, high temperature alerts, poor AQI count)

## Project Structure

```
lib/
├── main.dart                           # App entry point with routing
├── models/
│   └── patient.dart                    # PatientData model & mock data
├── screens/
│   ├── splash_screen.dart              # Initial splash screen
│   ├── login_selection_screen.dart     # Login type selection
│   ├── patient_login_screen.dart       # Patient authentication
│   ├── doctor_login_screen.dart        # Doctor authentication
│   ├── patient_dashboard_screen.dart   # Patient home view
│   └── doctor_dashboard_screen.dart    # Doctor home view
```

## Screens Overview

### 1. Splash Screen
- Displays app title: "IoT Based Vital Monitoring System"
- Medical icon (heart) with gradient background
- 5-second auto-redirect to login selection
- Loading indicator animation

### 2. Login Selection Screen
- Two button options: Patient & Doctor
- Color-coded (Green for Patient, Orange for Doctor)
- Medical services icon for branding

### 3. Patient Login Screen
- Email and password input fields
- Password visibility toggle
- Green theme consistent with patient role
- Proceeds to patient dashboard upon login

### 4. Doctor Login Screen
- Email and password input fields
- Password visibility toggle
- Orange theme consistent with doctor role
- Proceeds to doctor dashboard upon login

### 5. Patient Dashboard
**Displays:**
- Patient profile card (Name, Email, Age, Phone)
- Vital Signs Cards:
  - **AQI**: Air quality index (µg/m³)
  - **Body Temperature**: Core body temperature (°F)
  - **Room Temperature**: Ambient temperature (°F)
  - **Heart Rate**: Beats per minute (bpm)
- **ECG Chart**: Real-time electrocardiogram visualization
- Logout button in app bar

### 6. Doctor Dashboard
**Displays:**
- Summary Statistics Panel:
  - Total patients count
  - Patients with high temperature
  - Patients with poor air quality
- Expandable Patient List with:
  - Patient name, ID, and age
  - Current temperature (color-coded status)
  - Detailed vital signs on expansion
  - Contact information
  - Action buttons (View Chart, Send Alert)
- Logout functionality

## Data Models

### PatientData
```dart
class PatientData {
  String id;                    // Unique patient identifier
  String name;                  // Full name
  String email;                 // Email address
  int age;                      // Age in years
  String phoneNumber;           // Contact number
  double bodyTemperature;       // Current body temperature (°F)
  double roomTemperature;       // Room temperature (°F)
  int aqi;                      // Air Quality Index
  List<ECGDataPoint> ecgData;   // ECG data points for chart
}

class ECGDataPoint {
  DateTime time;                // Time of measurement
  double value;                 // ECG value
}
```

## Mock Data

The app includes 3 sample patients for demonstration:
- **John Doe** (35 years) - Normal vitals
- **Jane Smith** (28 years) - Slightly low temperature
- **Robert Johnson** (42 years) - Good condition

## Color Scheme

- **Primary (Blue)**: General UI elements
- **Green**: Patient-related screens
- **Orange**: Doctor-related screens
- **Red**: High temperature alerts
- **Blue**: AQI values
- **Pink**: Heart rate

## Navigation Flow

```
Splash Screen (5 sec)
         ↓
Login Selection
    ↙        ↘
Patient      Doctor
Login        Login
    ↓        ↓
Patient      Doctor
Dashboard    Dashboard
```

## Running the App

### Prerequisites
- Flutter SDK (3.10.4 or higher)
- Android Studio / Xcode (for respective platforms)

### Commands

```bash
# Get dependencies
flutter pub get

# Run the app
flutter run

# Run on specific device
flutter run -d <device-id>

# Build for release
flutter build apk      # Android
flutter build ios      # iOS
```

## Features in Detail

### ECG Chart Visualization
- Custom-painted ECG waveforms
- Grid lines for reference
- Color-coded per role (Green for patient, Orange for doctor)
- Dynamic scaling based on data range

### Patient Status Color Coding
- **Green**: Normal temperature (97-99°F)
- **Red**: High temperature (>99°F)
- **Blue**: Low temperature (<97°F)

### Vital Signs Interpretation
- **AQI**: Lower is better (Good: <50, Moderate: 50-100)
- **Temperature**: Normal range 97-99°F
- **Heart Rate**: Normal range 60-100 bpm

## Future Enhancements

1. **Backend Integration**
   - Firebase integration for real-time data
   - Cloud data storage
   - User authentication

2. **Additional Features**
   - Blood pressure monitoring
   - SpO2 (Oxygen saturation) tracking
   - Respiratory rate monitoring
   - Sleep data integration
   - Medicine reminders
   - Patient-Doctor messaging

3. **Advanced Analytics**
   - Historical data charts
   - Trend analysis
   - Health reports generation
   - Predictive alerts

4. **IoT Integration**
   - Connect to real medical devices
   - Bluetooth connectivity
   - Real-time data streaming
   - Sensor calibration

## Notes for Development

- All navigation uses Flutter's named routes
- Mock data is generated in `models/patient.dart`
- ECG data is simulated using sine wave calculation
- The app maintains responsive design across all screen sizes
- Material Design 3 is implemented for modern UI

## Contact & Support

For any questions about this project, refer to the code comments or documentation within each screen file.

---

**Project Type**: Final Year Project - IoT Based Vital Monitoring System
**Built with**: Flutter & Dart
**Platforms**: Android, iOS, Windows, macOS, Linux, Web
