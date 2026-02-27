Implement a "Personal Profile" screen in Flutter following these things 
Navigation:
- Screen opens when user taps avatar, username, or mention.
- Back button on top-left.
- Top-right has a Settings (three-dots or gear) button, tapping on this icon will show settings, and tapping on Edit Profile will open Settings -> Edit Profile Settings.
- Tapping Settings opens the Settings screen.

---

Profile states:
The screen must support two contexts:
1. Viewing Other User Profile
2. Viewing Own Profile

Viewing Other User:
- Show Follow button.
- Show follower/following counts.
- Allow navigation to buddies and posts.

Viewing Own Profile:
- Replace Follow button with "Edit Profile".
- Allow editing personal information.
- Settings button becomes primary control center.

Screen structure will be look like PROFILE_TAP_README.md, just different context
---

Edit Profile flow:

Trigger:
- Opened when user taps "Edit Profile".

Behavior:
- Must NOT feel like a traditional form.
- Use guided prompt-style inputs.

Fields:
- displayName
- headline (max 10 words)
- persona (new field)
- bio (auto-generated)

UI:
- Each question displayed as a card or section.
- Soft rounded input fields.
- Calm, friendly tone.


---

Settings screen:

Trigger:
- Opened from top-right button.

Layout:
- Clean vertical list with icons.

Sections:
- Edit Profile
- Manage Pets
- Privacy & Visibility
- Notifications
- Account & Security

Behavior:
- Each item navigates to sub-screen.
- Smooth transitions.

---

Interactions:

- Tap avatar or username → navigate to profile.
- Tap buddy → navigate recursively.
- Tap post → open post detail (or placeholder).
- Follow button:
  • Toggles state
  • Updates follower count
- Scroll:
  • Hero collapses smoothly
  • Title appears in app bar

---

Animation & UX:

- Smooth scroll transitions.
- Subtle fade-in for collapsing header title.
- Button state transitions animated.
- Avoid cluttered layout.

---

Style:

- Soft pastel color palette.
- Rounded UI elements.
- Calm, friendly, social atmosphere.
- Focus on "personal identity" feeling, not just data display.

---

Goal:

Create a modern personal profile experience similar to Instagram,
but enhanced with identity-driven storytelling and AI-assisted personalization.
The profile should feel like a digital representation of a person,
not just a collection of information.