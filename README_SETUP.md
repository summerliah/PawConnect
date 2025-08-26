# PAW CONNECT 🐾

A Flutter social media app for pet lovers built with Supabase backend.

## Features

- **User Authentication**: Sign up, login, password reset
- **Profile Management**: User profiles with pet information
- **Social Feed**: Post photos/videos of pets with captions
- **Interactions**: Like, comment, bookmark posts
- **Follow System**: Follow other pet owners
- **Pet Profiles**: Create profiles for multiple pets

## Setup Instructions

### 1. Supabase Setup

1. Go to [Supabase](https://supabase.com) and create a new project
2. In your Supabase dashboard, go to the SQL Editor
3. Copy and paste the contents of `database/schema.sql` and run it
4. Go to Settings > API to get your project URL and anon key
5. Update the credentials in `lib/config/supabase_config.dart`

### 2. Flutter Setup

1. Make sure you have Flutter installed
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the app

### 3. Supabase Configuration

Replace the placeholder values in `lib/config/supabase_config.dart`:

```dart
static const String supabaseUrl = 'YOUR_SUPABASE_PROJECT_URL';
static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
```

### 4. Database Schema

The database includes these main tables:
- `profiles` - User profile information
- `pets` - Pet profiles linked to users
- `posts` - Social media posts
- `media` - Photos/videos attached to posts
- `likes` - Post likes
- `comments` - Post comments
- `followers` - User follow relationships
- `bookmarks` - Saved posts

## Authentication Flow

1. **Splash Screen** - Shows app logo and checks authentication
2. **Login Page** - Email/password login with Supabase Auth
3. **Register Page** - New user registration with profile creation
4. **Home Page** - Main social feed

## Project Structure

```
lib/
├── config/
│   └── supabase_config.dart      # Supabase configuration
├── services/
│   ├── auth_service.dart         # Authentication methods
│   └── database_service.dart     # Database operations
├── splash_screen.dart            # Initial loading screen
├── login_page.dart              # User login
├── register_page.dart           # User registration
├── home_page.dart               # Main social feed
├── profile_page.dart            # User profile
├── post_page.dart               # Create new post
└── main.dart                    # App entry point
```

## Design

The UI follows the PAW CONNECT design with:
- Orange color scheme (#FF8C00)
- Rounded buttons and cards
- Pet-themed icons and imagery
- Clean, mobile-first layout

## Next Steps

1. Implement image upload to Supabase Storage
2. Add real-time features with Supabase Realtime
3. Implement push notifications
4. Add pet breed recognition
5. Location-based features for nearby pets

## Dependencies

- `supabase_flutter: ^2.0.0` - Supabase client
- `flutter/material.dart` - Material Design widgets

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

This project is licensed under the MIT License.
