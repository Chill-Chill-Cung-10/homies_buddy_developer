WARNING: READCAREFULLY AND SHOW YOUR UNDERSTANDING ABOUT MY REQUIREMENTS BEFORE IMPLEMENTING 
Implement a comment overlay for the Community feed in Flutter.

Behavior:
- When user taps the comment icon on a post card, show a comment overlay.
- The overlay should cover the entire screen with a semi-transparent dark background.
- The feed behind must remain visible but dimmed.
- The overlay appears as a rounded bottom sheet covering about 85–90% of screen height.

Layout of overlay:
1. At the top, display the post content preview:
   - author avatar
   - author name
   - post time
   - post text
   - media preview (if exists)
   - like and comment count row

2. Below the post preview, display:
   - a comment input field with placeholder "Your Comment..." and icon button send from Material 3 for sending comment
   - Filter Dropdown button to sort comments (Latest comments, Most reacted, Oldest comments) 

3. Display comment list:
   - commenter avatar
   - commenter name
   - comment text bubble
   - like count for comment
   - time data at when user sent that comment

Interaction:
- User can scroll everything (post + comment section) together.
- Background feed must not scroll when overlay is open.
- Tapping outside to close overlay and comment detail section.
- Keyboard should push comment input upward.

Implementation preference:
- Use showModalBottomSheet or custom overlay with Stack.
- Overlay must support dynamic comment list.
- Use existing PostCard data and Comment model.

Goal:
Replicate behavior similar to Instagram comment bottom sheet.
