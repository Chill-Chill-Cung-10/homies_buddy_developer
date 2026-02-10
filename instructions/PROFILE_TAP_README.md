WARNING: READCAREFULLY AND SHOW YOUR UNDERSTANDING ABOUT MY REQUIREMENTS BEFORE IMPLEMENTING 
Implement a Personal Profile Screen in Flutter.

Navigation behavior:
- When user taps on a profile avatar or username in the feed,
  navigate to a PersonalProfileScreen.
- Add a back arrow button at the top-left corner.
- Pressing back returns to previous screen.
- Scroll down if user want to see detailed information 
Profile data comes from User model.

Screen layout:
Layout 1: Hero Screen
Navigation behavior:
- Screen opens when user taps on a profile in feed.
- Add back arrow button at top-left corner.
- Pressing back returns to previous screen.

Hero header layout:
- Use a fullscreen background image as profile cover.
- Cover image occupies full screen height initially.

Header content:
- On the same row, display user avatar, fullname (big size in fontsize) on the same column with username (smaller in fontsize), and a follow button.
- Display a title quote. (Limit to 10 words)
- Display subtitle quote text below. (Limit to 40 words)
- Add subtle gradient overlay at bottom to improve text readability.

Scroll behavior:
- User scrolls upward to reveal profile content.
- Header collapses or scrolls away while content scrolls normally.
- Content below includes:
    • buddy profiles horizontal list
    • list of user posts using Social Post Card
- Posts scroll vertically.

Interaction:
- Follow button toggles based on isFollowedByMe.
- Buddy profile tap navigates to buddy profile.
- Post tap opens post detail.

Implementation guidance:
- Use CustomScrollView with SliverAppBar or nested scroll.
- Optimize space and flexible fonts for title and subtitle quote with words limits
- Use gradient overlay on image.
- Optimize scroll performance.

Layout 2: Detailed Post and Friends
1. Header section:
   - Back arrow button.
   - Display fullname as screen title.
   - Clean minimal layout similar to social media profile screens.

2. Buddy profiles section:
   - Horizontal scroll list of buddy_profiles.
   - Each item shows avatar and name.
   - Tapping a buddy opens that buddy's profile.

3. Post feed section:
   - When user scrolls down, show list of posts created by this user and buddies that is in home .
   - Posts use existing Social Post Card widget.
   - Posts must scroll vertically.

4. Interaction:
   - Profile screen must support vertical scrolling.
   - Header remains on top initially.
   - Posts load dynamically when scrolling.

5. Follow state:
   - Use isFollowedByMe to display Follow/Following button.
   - Button toggles follow state.

Implementation guidance:
- Use existing Social Post Card widget.
- Load posts dynamically.
- Optimize scroll performance.

Goal:
Create a profile page similar to Instagram or Facebook profile, where user information appears first, and scrolling reveals user posts.
