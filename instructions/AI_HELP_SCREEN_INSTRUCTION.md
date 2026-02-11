You are a Flutter UI engineer. Build only the UI for my “AI Help / Ask For Help” tab exactly like the attached design screenshot.

CONTEXT / GOAL
- Screen name: HelpScreen (help_screen.dart)
- I am ONLY building UI now. Do NOT implement API calls, recommendation logic, swipe logic, AI chat logic, or state management.
- The “recommendation cards” (e.g., “Watering Your Fern…”) are placeholders; keep them static mock widgets for now.

FOLDER STRUCTURE (IMPORTANT)
- help_screen.dart is located at: help/presentation/screens/help_screen.dart
- My images are inside a folder at the SAME LEVEL:
  help/presentation/screens/img/
- Use Image.asset() to load images from that folder.
  Example: Image.asset('help/presentation/screens/img/<file>.png')
  (If you prefer a shorter path, tell me what to add to pubspec.yaml.)

DESIGN REQUIREMENTS (match screenshot)
1) Background: soft warm gradient / creamy peach tone (top slightly pink, bottom creamy).
2) Top row (SafeArea):
   - Left: “Ask For Help” text with a dropdown arrow icon (like a selectable title, but no real action).
   - Right: bell/notification icon.
3) Center hero:
   - Cute cat image centered.
4) Title text:
   - “Hello, Name”
   - “How can I help you today?”
   - Use warm orange for the text, bold, friendly.
5) Search input row:
   - Rounded white text field with hint “Ask anything”.
   - On the right: circular send button with arrow icon (no action).
6) Recommendation section (placeholder UI):
   - 2 large rounded cards in a row, with soft shadows.
   - Each card includes:
     - a colored rounded rectangle image area at top (e.g., plant / sheep icon)
     - text below like:
       - “Watering Your Fern - Every 3 Days”
       - “Brushing Your Sheep - Daily Connection”
   - Make the cards responsive and not overflow on small screens.
7) Bottom navigation:
   - 4 items: Feeds, Neighbors, Mimi, Settings.
   - The current tab is “Mimi” (highlighted/selected).
   - Only UI, no navigation.

CODE QUALITY REQUIREMENTS
- Use a StatelessWidget (or StatefulWidget only if absolutely needed for UI layout).
- Create small reusable widgets (e.g., _TopBar, _SearchBar, _RecommendationCard).
- Use constants for paddings, radii, and text styles.
- Use SafeArea and avoid overflow on common phones.
- Don’t use external packages.
- Ensure all paddings and font sizes look close to the screenshot.
- Use LayoutBuilder / MediaQuery to make spacing scale slightly for small vs large screens.
- Use a SingleChildScrollView so content doesn’t overflow.

OUTPUT
- Provide the full help_screen.dart code in one file.
- Also show the pubspec.yaml assets snippet needed to load images from help/presentation/screens/img/.
