# SIH 2025 - Stack Nova Prototype

> **Lakshya** - A comprehensive Flutter + FastAPI application for Smart India Hackathon 2025

## 🚀 Project Overview

This project is a full-stack application built for SIH 2025, featuring:

- **Frontend**: Flutter mobile application (`lakshya-ui/`)
- **Backend**: FastAPI Python server (`backend/`)

## 📱 Frontend (Flutter)

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK (included with Flutter)
- Android Studio / VS Code with Flutter extensions
- Android SDK for Android development
- Xcode (for iOS development on macOS)

### Getting Started

1. **Navigate to the Flutter app directory:**

   ```bash
   cd lakshya-ui
   ```

2. **Install dependencies:**

   ```bash
   flutter pub get
   ```

3. **Run the app:**

   ```bash
   # For development
   flutter run

   # For specific platform
   flutter run -d android
   flutter run -d ios
   flutter run -d windows
   ```

4. **Build for production:**

   ```bash
   # Android APK
   flutter build apk

   # Android App Bundle
   flutter build appbundle

   # iOS
   flutter build ios
   ```

### Flutter Project Structure

```
lakshya-ui/
├── lib/
│   ├── main.dart          # App entry point
│   ├── core/              # Core utilities and extensions
│   ├── features/          # Feature-based modules
│   ├── preview/           # Preview components
│   └── theme/             # App theming
├── assets/
│   └── images/            # Image assets
├── android/               # Android platform code
├── ios/                   # iOS platform code
└── web/                   # Web platform code
```

## 🔧 Backend (FastAPI)

### Prerequisites

- Python 3.8+
- pip (Python package manager)

### Getting Started

1. **Navigate to the backend directory:**

   ```bash
   cd backend
   ```

2. **Create and activate virtual environment:**

   ```bash
   # Windows
   python -m venv myenv
   myenv\Scripts\activate

   # macOS/Linux
   python3 -m venv myenv
   source myenv/bin/activate
   ```

3. **Install dependencies:**

   ```bash
   pip install fastapi uvicorn sqlalchemy psycopg2 pydantic
   ```

4. **Run the server:**

   ```bash
   uvicorn main:app --reload
   ```

   The API will be available at `http://localhost:8000`

   Interactive API documentation: `http://localhost:8000/docs`

### Backend Dependencies

- **FastAPI**: Modern, fast web framework for building APIs
- **Uvicorn**: ASGI server for running FastAPI
- **SQLAlchemy**: SQL toolkit and ORM
- **Psycopg2**: PostgreSQL adapter for Python
- **Pydantic**: Data validation using Python type annotations

## 🛠️ Development Setup

### 1. Clone the Repository

```bash
git clone <repository-url>
cd "SIH 2025(Stack Nova)/Prototype"
```

### 2. Backend Setup

```bash
cd backend
python -m venv myenv
# Windows
myenv\Scripts\activate
# macOS/Linux
source myenv/bin/activate

pip install -r requirements.txt  # If you have requirements.txt
# Or install manually:
pip install fastapi uvicorn sqlalchemy psycopg2 pydantic
```

### 3. Frontend Setup

```bash
cd lakshya-ui
flutter pub get
```

### 4. Run Development Servers

**Terminal 1 - Backend:**

```bash
cd backend
myenv\Scripts\activate  # Windows
uvicorn main:app --reload
```

**Terminal 2 - Frontend:**

```bash
cd lakshya-ui
flutter run
```

## 📚 Available Scripts

### Flutter Commands

- `flutter pub get` - Install dependencies
- `flutter pub upgrade` - Upgrade dependencies
- `flutter clean` - Clean build artifacts
- `flutter analyze` - Analyze code for issues
- `flutter test` - Run tests
- `flutter build apk` - Build Android APK
- `flutter build web` - Build for web

### Python/FastAPI Commands

- `uvicorn main:app --reload` - Run development server
- `pip freeze > requirements.txt` - Generate requirements file
- `pip install -r requirements.txt` - Install from requirements
- `python -m pytest` - Run tests (if configured)

## 🗂️ Project Structure

```
SIH 2025(Stack Nova)/Prototype/
├── backend/                 # FastAPI backend
│   ├── myenv/              # Python virtual environment
│   ├── main.py             # FastAPI app entry point
│   └── requirements.txt    # Python dependencies
├── lakshya-ui/             # Flutter frontend
│   ├── lib/                # Dart source code
│   ├── assets/             # App assets
│   ├── android/            # Android platform
│   ├── ios/                # iOS platform
│   └── pubspec.yaml        # Flutter dependencies
├── .gitignore              # Git ignore rules
└── README.md               # This file
```

## 🔗 API Integration

The Flutter app communicates with the FastAPI backend through RESTful APIs:

- **Base URL**: `http://localhost:8000` (development)
- **API Documentation**: `http://localhost:8000/docs`
- **Alternative Docs**: `http://localhost:8000/redoc`

## 🧪 Testing

### Backend Testing

```bash
cd backend
python -m pytest  # If tests are configured
```

### Frontend Testing

```bash
cd lakshya-ui
flutter test
```

## 📦 Building for Production

### Backend Deployment

1. Set up production environment variables
2. Configure database connection
3. Deploy using services like Heroku, AWS, or DigitalOcean

### Frontend Deployment

```bash
cd lakshya-ui

# Android
flutter build appbundle
# Generate signed bundle for Play Store

# iOS
flutter build ios
# Archive and upload to App Store Connect

# Web
flutter build web
# Deploy to web hosting service
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📋 Team: Stack Nova

- Team Member 1
- Team Member 2
- Team Member 3
- Team Member 4
- Team Member 5
- Team Member 6

## 📄 License

This project is developed for Smart India Hackathon 2025.

## 🆘 Troubleshooting

### Common Issues

1. **Flutter build issues:**

   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

2. **Python environment issues:**

   ```bash
   deactivate
   rm -rf myenv  # or rmdir /s myenv on Windows
   python -m venv myenv
   # Reactivate and reinstall packages
   ```

3. **Port conflicts:**
   - FastAPI default: `8000`
   - Flutter web default: `3000`
   - Change ports if needed: `uvicorn main:app --port 8080`

## 📞 Support

For questions and support regarding this SIH 2025 project, please contact the Stack Nova team.

---

**Built with ❤️ for Smart India Hackathon 2025**
