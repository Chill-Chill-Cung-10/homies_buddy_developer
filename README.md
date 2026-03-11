# homies_buddy_developer

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Supabase Secure Setup

Do not hardcode Supabase values in source code.

Create a `.env` file at project root with:

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your_anon_or_publishable_key
```

Then run normally:

```powershell
flutter run
```

Recommended for CI/CD:
- Store `SUPABASE_URL` and `SUPABASE_ANON_KEY` in pipeline secrets.
- Generate `.env` from secrets before build/run.
