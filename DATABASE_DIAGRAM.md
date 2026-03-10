# Database Diagram

## Entity Relationship Overview

```
user_profile (1) ──── (N) feed_post
user_profile (1) ──── (N) feed_comment
user_profile (1) ──── (N) moment_note
user_profile (1) ──── (1) pet
user_profile (1) ──── (1) user_emotional_trend
user_profile (1) ──── (N) help_conversation_history
user_profile (1) ──── (N) post_likes
user_profile (1) ──── (N) comment_reacts
user_profile (1) ──── (N) user_follows (as follower)
user_profile (1) ──── (N) user_follows (as following)
user_profile (1) ──── (N) user_buddies
feed_post    (1) ──── (N) feed_comment
feed_post    (1) ──── (N) media_file
feed_post    (1) ──── (N) post_likes
feed_comment (1) ──── (N) comment_reacts
moment_note  (1) ──── (1) note_analysis
pet          (1) ──── (N) pet_state_snapshot
help_conversation_history (1) ──── (N) help_chat_message
```

---

## Enum Types

```sql
CREATE TYPE public.user_role AS ENUM ('user', 'admin');
CREATE TYPE public.post_privacy AS ENUM ('public', 'friends', 'private');
CREATE TYPE public.media_type AS ENUM ('image', 'video');
CREATE TYPE public.pet_mood AS ENUM ('idle', 'happy', 'sad', 'excited', 'tired');
CREATE TYPE public.user_tone AS ENUM ('positive', 'neutral', 'negative', 'anxious', 'calm');
CREATE TYPE public.emotional_trend AS ENUM ('improving', 'stable', 'declining');
CREATE TYPE public.icon_type AS ENUM ('emoji', 'icon', 'image');
```

---

## Tables

### user_profile

Primary user identity and profile information.

```sql
CREATE TABLE public.user_profile (
  id                TEXT        NOT NULL,
  full_name         TEXT        NOT NULL,
  username          TEXT        NOT NULL,
  email             TEXT        NOT NULL,
  avatar_url        TEXT        NOT NULL DEFAULT 'https://picsum.photos/150/150?random=500',
  cover_url         TEXT        NOT NULL DEFAULT 'https://picsum.photos/800/1200?random=500',
  follower_count    INTEGER     NOT NULL DEFAULT 0,
  following_count   INTEGER     NOT NULL DEFAULT 0,
  role              user_role   NOT NULL DEFAULT 'user',
  date_of_birth     TIMESTAMPTZ NOT NULL,
  is_email_verified BOOLEAN              DEFAULT TRUE,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at        TIMESTAMPTZ          DEFAULT NOW(),

  CONSTRAINT user_profile_pkey     PRIMARY KEY (id),
  CONSTRAINT user_profile_email_key   UNIQUE (email),
  CONSTRAINT user_profile_username_key UNIQUE (username)
);
```

---

### feed_post

Posts created by users in the social feed.

```sql
CREATE TABLE public.feed_post (
  post_id       TEXT         NOT NULL DEFAULT (gen_random_uuid())::TEXT,
  author_id     TEXT         NOT NULL,
  author_name   TEXT         NOT NULL,
  author_avatar TEXT         NOT NULL DEFAULT '',
  content_text  TEXT         NOT NULL DEFAULT '',
  hashtags      TEXT[]       NOT NULL DEFAULT '{}',
  mentions      TEXT[]       NOT NULL DEFAULT '{}',
  reacts_count  INTEGER      NOT NULL DEFAULT 0,
  comment_count INTEGER      NOT NULL DEFAULT 0,
  privacy       post_privacy NOT NULL DEFAULT 'public',
  created_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
  updated_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),

  CONSTRAINT feed_post_pkey          PRIMARY KEY (post_id),
  CONSTRAINT feed_post_author_id_fkey FOREIGN KEY (author_id)
    REFERENCES public.user_profile (id)
);
```

---

### feed_comment

Comments on feed posts.

```sql
CREATE TABLE public.feed_comment (
  comment_id    TEXT        NOT NULL DEFAULT (gen_random_uuid())::TEXT,
  post_id       TEXT        NOT NULL,
  author_id     TEXT        NOT NULL,
  author_name   TEXT        NOT NULL,
  author_avatar TEXT        NOT NULL DEFAULT '',
  content_text  TEXT        NOT NULL,
  react_count   INTEGER     NOT NULL DEFAULT 0,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  CONSTRAINT feed_comment_pkey           PRIMARY KEY (comment_id),
  CONSTRAINT feed_comment_post_id_fkey   FOREIGN KEY (post_id)
    REFERENCES public.feed_post (post_id),
  CONSTRAINT feed_comment_author_id_fkey FOREIGN KEY (author_id)
    REFERENCES public.user_profile (id)
);
```

---

### media_file

Media attachments (images/videos) linked to feed posts.

```sql
CREATE TABLE public.media_file (
  id                  TEXT        NOT NULL DEFAULT (gen_random_uuid())::TEXT,
  post_id             TEXT        NOT NULL,
  media_url           TEXT        NOT NULL,
  thumbnail_url       TEXT,
  media_type          media_type  NOT NULL,
  media_aspect_ratio  FLOAT8      NOT NULL DEFAULT 1.0,
  width               INTEGER     NOT NULL DEFAULT 0,
  height              INTEGER     NOT NULL DEFAULT 0,
  duration_seconds    INTEGER,

  CONSTRAINT media_file_pkey         PRIMARY KEY (id),
  CONSTRAINT media_file_post_id_fkey FOREIGN KEY (post_id)
    REFERENCES public.feed_post (post_id)
);
```

---

### post_likes

Junction table: users who liked a post.

```sql
CREATE TABLE public.post_likes (
  user_id    TEXT        NOT NULL,
  post_id    TEXT        NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  CONSTRAINT post_likes_pkey         PRIMARY KEY (user_id, post_id),
  CONSTRAINT post_likes_user_id_fkey FOREIGN KEY (user_id)
    REFERENCES public.user_profile (id),
  CONSTRAINT post_likes_post_id_fkey FOREIGN KEY (post_id)
    REFERENCES public.feed_post (post_id)
);
```

---

### comment_reacts

Junction table: users who reacted to a comment.

```sql
CREATE TABLE public.comment_reacts (
  user_id    TEXT        NOT NULL,
  comment_id TEXT        NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  CONSTRAINT comment_reacts_pkey            PRIMARY KEY (user_id, comment_id),
  CONSTRAINT comment_reacts_user_id_fkey    FOREIGN KEY (user_id)
    REFERENCES public.user_profile (id),
  CONSTRAINT comment_reacts_comment_id_fkey FOREIGN KEY (comment_id)
    REFERENCES public.feed_comment (comment_id)
);
```

---

### moment_note

Personal journal-style notes written by users.

```sql
CREATE TABLE public.moment_note (
  id                TEXT        NOT NULL DEFAULT (gen_random_uuid())::TEXT,
  user_id           TEXT        NOT NULL,
  author_name       TEXT        NOT NULL,
  author_avatar_url TEXT        NOT NULL DEFAULT '',
  text_content      TEXT        NOT NULL DEFAULT '',
  media_urls        TEXT[]      NOT NULL DEFAULT '{}',
  created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  CONSTRAINT moment_note_pkey         PRIMARY KEY (id),
  CONSTRAINT moment_note_user_id_fkey FOREIGN KEY (user_id)
    REFERENCES public.user_profile (id)
);
```

---

### note_analysis

AI-generated emotional analysis results for each moment note.

```sql
CREATE TABLE public.note_analysis (
  id                   TEXT        NOT NULL DEFAULT (gen_random_uuid())::TEXT,
  note_id              TEXT        NOT NULL,
  user_id              TEXT        NOT NULL,
  last_user_tone       user_tone   NOT NULL,
  current_tone_predict user_tone   NOT NULL,
  tone_repeat          BOOLEAN     NOT NULL DEFAULT FALSE,
  level                INTEGER     NOT NULL,
  analyzed_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  raw_llm_response     TEXT,

  CONSTRAINT note_analysis_pkey         PRIMARY KEY (id),
  CONSTRAINT note_analysis_note_id_key  UNIQUE (note_id),
  CONSTRAINT note_analysis_level_check  CHECK (level >= 1 AND level <= 5),
  CONSTRAINT note_analysis_note_id_fkey FOREIGN KEY (note_id)
    REFERENCES public.moment_note (id),
  CONSTRAINT note_analysis_user_id_fkey FOREIGN KEY (user_id)
    REFERENCES public.user_profile (id)
);
```

---

### pet

Virtual companion pet, one per user.

```sql
CREATE TABLE public.pet (
  id                 TEXT        NOT NULL DEFAULT (gen_random_uuid())::TEXT,
  user_id            TEXT        NOT NULL,
  name               TEXT        NOT NULL,
  baseline_energy    FLOAT8      NOT NULL,
  energy             FLOAT8      NOT NULL DEFAULT 1.0,
  streak             INTEGER     NOT NULL DEFAULT 0,
  current_mood       pet_mood             DEFAULT 'idle',
  last_interacted_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  CONSTRAINT pet_pkey                  PRIMARY KEY (id),
  CONSTRAINT pet_user_id_key           UNIQUE (user_id),
  CONSTRAINT pet_baseline_energy_check CHECK (baseline_energy >= 0.0 AND baseline_energy <= 1.0),
  CONSTRAINT pet_energy_check          CHECK (energy >= 0.0 AND energy <= 1.0),
  CONSTRAINT pet_user_id_fkey          FOREIGN KEY (user_id)
    REFERENCES public.user_profile (id)
);
```

---

### pet_state_snapshot

Historical snapshots of a pet's state for tracking changes over time.

```sql
CREATE TABLE public.pet_state_snapshot (
  id                       TEXT        NOT NULL DEFAULT (gen_random_uuid())::TEXT,
  pet_id                   TEXT        NOT NULL,
  user_id                  TEXT        NOT NULL,
  delta_t                  FLOAT8      NOT NULL,
  visit_count_today        INTEGER     NOT NULL DEFAULT 0,
  interaction_count_today  INTEGER     NOT NULL DEFAULT 0,
  energy_at_snapshot       FLOAT8      NOT NULL,
  time_of_day              INTEGER     NOT NULL,
  mood_at_snapshot         pet_mood             DEFAULT 'idle',
  recorded_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  CONSTRAINT pet_state_snapshot_pkey              PRIMARY KEY (id),
  CONSTRAINT pet_state_snapshot_time_of_day_check CHECK (time_of_day >= 0 AND time_of_day <= 23),
  CONSTRAINT pet_state_snapshot_pet_id_fkey       FOREIGN KEY (pet_id)
    REFERENCES public.pet (id),
  CONSTRAINT pet_state_snapshot_user_id_fkey      FOREIGN KEY (user_id)
    REFERENCES public.user_profile (id)
);
```

---

### user_emotional_trend

Aggregated emotional trend data per user, updated over time.

```sql
CREATE TABLE public.user_emotional_trend (
  id                  TEXT            NOT NULL DEFAULT (gen_random_uuid())::TEXT,
  user_id             TEXT            NOT NULL,
  emotional_trend     emotional_trend NOT NULL DEFAULT 'stable',
  emotional_momentum  FLOAT8          NOT NULL DEFAULT 0,
  tone_history_7d     TEXT[]          NOT NULL DEFAULT '{}',
  dominant_tone       user_tone       NOT NULL DEFAULT 'neutral',
  updated_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),

  CONSTRAINT user_emotional_trend_pkey            PRIMARY KEY (id),
  CONSTRAINT user_emotional_trend_user_id_key     UNIQUE (user_id),
  CONSTRAINT user_emotional_trend_momentum_check  CHECK (
    emotional_momentum >= -1.0 AND emotional_momentum <= 1.0
  ),
  CONSTRAINT user_emotional_trend_user_id_fkey    FOREIGN KEY (user_id)
    REFERENCES public.user_profile (id)
);
```

---

### help_conversation_history

AI help chat sessions per user.

```sql
CREATE TABLE public.help_conversation_history (
  id              TEXT        NOT NULL DEFAULT (gen_random_uuid())::TEXT,
  user_id         TEXT        NOT NULL,
  title           TEXT        NOT NULL DEFAULT 'New Chat',
  preview         TEXT        NOT NULL DEFAULT '',
  last_message_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  CONSTRAINT help_conversation_history_pkey         PRIMARY KEY (id),
  CONSTRAINT help_conversation_history_user_id_fkey FOREIGN KEY (user_id)
    REFERENCES public.user_profile (id)
);
```

---

### help_chat_message

Individual messages within a help conversation.

```sql
CREATE TABLE public.help_chat_message (
  id              TEXT        NOT NULL DEFAULT (gen_random_uuid())::TEXT,
  conversation_id TEXT        NOT NULL,
  text            TEXT        NOT NULL DEFAULT '',
  is_user         BOOLEAN     NOT NULL,
  image_urls      TEXT[]      NOT NULL DEFAULT '{}',
  timestamp       TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  CONSTRAINT help_chat_message_pkey                    PRIMARY KEY (id),
  CONSTRAINT help_chat_message_conversation_id_fkey    FOREIGN KEY (conversation_id)
    REFERENCES public.help_conversation_history (id)
);
```

---

### help_suggestion

Predefined help topic suggestions displayed to users.

```sql
CREATE TABLE public.help_suggestion (
  id        TEXT      NOT NULL DEFAULT (gen_random_uuid())::TEXT,
  title     TEXT      NOT NULL,
  icon_type icon_type NOT NULL,

  CONSTRAINT help_suggestion_pkey PRIMARY KEY (id)
);
```

---

### user_follows

Directed follow relationships between users.

```sql
CREATE TABLE public.user_follows (
  follower_id  TEXT        NOT NULL,
  following_id TEXT        NOT NULL,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  CONSTRAINT user_follows_pkey              PRIMARY KEY (follower_id, following_id),
  CONSTRAINT user_follows_follower_id_fkey  FOREIGN KEY (follower_id)
    REFERENCES public.user_profile (id),
  CONSTRAINT user_follows_following_id_fkey FOREIGN KEY (following_id)
    REFERENCES public.user_profile (id)
);
```

---

### user_buddies

Mutual buddy/friend relationships between users.

```sql
CREATE TABLE public.user_buddies (
  user_id    TEXT        NOT NULL,
  buddy_id   TEXT        NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  CONSTRAINT user_buddies_pkey          PRIMARY KEY (user_id, buddy_id),
  CONSTRAINT user_buddies_user_id_fkey  FOREIGN KEY (user_id)
    REFERENCES public.user_profile (id),
  CONSTRAINT user_buddies_buddy_id_fkey FOREIGN KEY (buddy_id)
    REFERENCES public.user_profile (id)
);
```

---

## Summary Table

| Table                      | Rows (est.) | PK Type          | Notable Constraints               |
|----------------------------|-------------|------------------|-----------------------------------|
| `user_profile`             | Users        | `text` (auth id) | UNIQUE email, UNIQUE username     |
| `feed_post`                | Posts        | UUID text        | FK → user_profile                 |
| `feed_comment`             | Comments     | UUID text        | FK → feed_post, user_profile      |
| `media_file`               | Media        | UUID text        | FK → feed_post                    |
| `post_likes`               | Likes        | Composite        | FK → user_profile, feed_post      |
| `comment_reacts`           | Reacts       | Composite        | FK → user_profile, feed_comment   |
| `moment_note`              | Notes        | UUID text        | FK → user_profile                 |
| `note_analysis`            | Analyses     | UUID text        | UNIQUE note_id, level 1–5         |
| `pet`                      | Pets         | UUID text        | UNIQUE user_id, energy 0.0–1.0    |
| `pet_state_snapshot`       | Snapshots    | UUID text        | time_of_day 0–23                  |
| `user_emotional_trend`     | Trends       | UUID text        | UNIQUE user_id, momentum ±1.0     |
| `help_conversation_history`| Sessions     | UUID text        | FK → user_profile                 |
| `help_chat_message`        | Messages     | UUID text        | FK → help_conversation_history    |
| `help_suggestion`          | Suggestions  | UUID text        | —                                 |
| `user_follows`             | Follows      | Composite        | FK → user_profile (×2)            |
| `user_buddies`             | Buddies      | Composite        | FK → user_profile (×2)            |