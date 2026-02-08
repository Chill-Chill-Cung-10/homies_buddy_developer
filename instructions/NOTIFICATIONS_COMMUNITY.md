WARNING: READCAREFULLY AND SHOW YOUR UNDERSTANDING ABOUT MY REQUIREMENTS (INCLUDING MODELS WOULD BE USED FOR THIS INSTRUCTION) BEFORE IMPLEMENTING 
Implement a dedicated Notification screen in Flutter.

Navigation behavior:
- When user taps the notification bell icon in the Community screen, navigate to a new screen called NotificationScreen.
- Use Navigator.push for navigation.
- NotificationScreen must have a back arrow button in the top-left corner.
- Pressing the back arrow returns the user to Community screen.
- Navigation behavior should match Instagram notification page style.

Notification screen layout:

1. App bar:
   - Back arrow button on the left.
   - Title: "Notifications".
   - Clean minimal header style.

2. Notification list:
   - Display notifications using NotificationModel.
   - List must be scrollable.
   - Each notification item includes:
        • actor avatar
        • notification text
        • optional content preview
        • timestamp
        • unread indicator

3. Interaction:
   - Tapping a notification navigates using notification.deepLink.
   - Notification becomes read after tapping.
4. Unread notification styling:

- Notifications with isRead == false must have a visual distinction.
- Use a light colored background highlight for unread items.
- Read notifications should use normal transparent background.

Style behavior:
- Unread notification item should have:
    • slightly colored background (light blue or theme highlight)
    • stronger text emphasis if needed
- Read notifications appear with normal background.

Notification Interaction:
- When user taps a notification item,
  it becomes read immediately.
- UI must update to remove highlight.

Timestamp formatting:
- Notifications must display time in relative format.
- Examples:
    • less than 1 minute → "Vừa xong"
    • minutes ago → "18 phút trước"
    • hours ago → "2 giờ trước"
    • yesterday → "Hôm qua"
    • within 7 days → "3 ngày trước"
    • older → display formatted date (e.g., 12/02/2026)
- Timestamp must be calculated from createdAt field of NotificationModel.

Implementation guidance:
- Use existing NotificationModel.
- List must support dynamic updates.
- Optimize scrolling performance.
- Follow Instagram-style clean layout.

Goal:
Create a full notification page similar to Instagram, instead of an overlay panel.



