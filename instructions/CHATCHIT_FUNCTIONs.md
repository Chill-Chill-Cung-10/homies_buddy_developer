Design a mobile Chat List screen for a messaging feature inside a cozy “Digital Home” app.

Visual style must match:
- Soft peach gradient background like a warm home environment
- Rounded cards, gentle shadows, minimal harsh edges
- Calm, emotional, non-aggressive UI
- Inspired by Instagram DM but softer and more peaceful

Data mapping (IMPORTANT):
- Each item represents a Conversation
- Display:
  • participant avatar (use home-style avatar, not generic user)
  • participant name (home name)
  • lastMessage (preview text)
  • lastUpdated (relative time)
  • unreadCount (badge indicator)

Layout:
- Top header:
  • Title: app name (e.g. “Amicute”)
  • Right icons: search, notifications, chat icon
- Search bar below header (rounded, soft background)
- Horizontal list of active homes (story-style avatars)
- Vertical list of conversations

Conversation item:
- Large rounded card
- Avatar on left (circle)
- Name + message preview stacked
- Time on right
- Unread badge (small rounded bubble)
- Unread conversations have slightly highlighted background

Interaction:
- Tap opens chat detail screen
- Smooth scrolling
- Clean spacing, not dense like WhatsApp

Mood:
Feels like visiting other homes, not just chatting
Then
Design a mobile Chat Detail screen for a messaging feature in a cozy “Digital Home” app.

Style:
- Same soft peach / warm gradient background as main app
- Rounded UI, smooth spacing, minimal sharp lines
- Calm, intimate, emotional tone

Header:
- Back arrow (top-left)
- Home avatar + home name
- Optional status text (e.g. “active now”)
- Minimal and clean

Message list:
- Based on Message model:
  • senderId
  • content
  • type (text, image)
  • createdAt
  • status

UI behavior:
- Messages from current user → right aligned
- Messages from others → left aligned

Message bubbles:
- Rounded, soft edges
- Slight color difference:
  • outgoing: warm accent (peach/orange tint)
  • incoming: light neutral

Support:
- text messages
- image messages (rounded preview)

Message status (IMPORTANT):
- sending → subtle loading indicator
- sent → single check
- delivered → double check
- seen → small avatar or highlighted check
- failed → error icon

Spacing:
- Airy layout, not dense
- Messages grouped naturally

Background:
- Subtle cozy environment feel (soft gradient, very light illustration hints)
- Do NOT distract from messages

Input area:
- Rounded input field
- Placeholder: “Send a message...”
- Left: optional "+" button (media)
- Right: send button
- Keyboard pushes UI up

Interaction:
- Smooth scroll to latest message
- Tap input → focus
- Messages animate slightly when appearing

Emotion:
Feels like a quiet conversation inside a warm home
Not fast-paced, not stressful

The UI must strictly follow this data structure:

Conversation:
- id
- participantIds
- lastMessage
- lastUpdated
- unreadCount

Message:
- id
- conversationId
- senderId
- content
- type (text, image)
- createdAt
- status (sending, sent, delivered, seen, failed)

MessageReceipt:
- messageId
- userId
- deliveredAt
- seenAt

Ensure UI elements correspond exactly to these fields.