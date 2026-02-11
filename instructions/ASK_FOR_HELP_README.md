Implement an "Ask For Help" screen in Flutter with chat assistant behavior.

Navigation:
- Screen opens from Help tab.
- Top-right has a three-dots button.
- Tapping it opens a sidebar panel showing conversation history.
- Sidebar slides in from the right.

Chat states:
The screen must support two states:
1. New Chat state
2. Active Chat state

New Chat behavior:
- Display assistant mascot and welcome message.
- Message must appear with typing animation effect:
  "Hi there! How can I help you grow today?"
- Typing effect should simulate characters appearing gradually.
- Suggested help cards are visible only in this state.

Active Chat behavior:
- When user sends a message or selects a suggestion:
  • Help cards disappear.
  • Chat conversation view becomes active.
  • Messages appear in chat bubbles.
- Mascot and welcome typing message should no longer repeat.

Help suggestion cards:
- Display cards with soft pastel backgrounds.
- Cards contain icon + help topic text.
- Tapping a card autofills or sends message.
- Cards only appear in New Chat state.

Chat input area:
- Bottom text input with rounded design.
- Send button on right side.
- Keyboard pushes layout upward.

Media input button:
- Add a "+" button near the input field.
- Tapping "+" opens a dropdown menu.
- Dropdown options:
    • Take Photo (open camera)
    • Choose Image (open gallery)
- Selected images are attached to chat message.
- Attached images become part of prompt data.

Conversation history sidebar:
- Opens from three-dots menu.
- Shows conversation history list.
- Each item displays title, preview, timestamp.
- Selecting history loads conversation.
- Sidebar closes by swipe or tap outside.

Interaction rules:
- User messages appear on right.
- Assistant responses appear on left.
- Chat scrolls automatically to newest message.

Style:
- Friendly pastel gradient background.
- Soft rounded UI elements.
- Calm assistant-like atmosphere.

Goal:
Create a modern assistant chat screen similar to Copilot or AI companion apps, supporting history navigation, typing animation, suggestion cards, and media input.
