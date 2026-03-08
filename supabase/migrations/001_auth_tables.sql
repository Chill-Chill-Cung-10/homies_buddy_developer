-- ============================================================================
-- HOMIES BUDDY - AUTH & USER TABLES MIGRATION
-- Based on DATABASE_DIAGRAM.md
-- ============================================================================

-- Enable UUID extension if not exists
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================================
-- 1. AUTH_USERS TABLE (Lightweight auth info)
-- ============================================================================
-- Stores basic authentication info synced from Firebase Auth
-- Primary source: Firebase Auth, this is a mirror for queries

CREATE TABLE IF NOT EXISTS auth_users (
    id              TEXT PRIMARY KEY,                    -- Firebase UID
    email           TEXT NOT NULL UNIQUE,
    full_name       TEXT NOT NULL DEFAULT '',
    avatar_url      TEXT,
    phone_number    TEXT,
    date_of_birth   TIMESTAMPTZ,
    is_email_verified BOOLEAN NOT NULL DEFAULT FALSE,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Index for email lookups
CREATE INDEX IF NOT EXISTS idx_auth_users_email ON auth_users(email);

-- Auto-update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_auth_users_updated_at
    BEFORE UPDATE ON auth_users
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- 2. USER_PROFILES TABLE (Full social profile)
-- ============================================================================
-- Complete profile for community features
-- 1:1 relationship with auth_users (same id)

CREATE TABLE IF NOT EXISTS user_profiles (
    id              TEXT PRIMARY KEY REFERENCES auth_users(id) ON DELETE CASCADE,
    username        TEXT UNIQUE,                         -- @handle, can be null initially
    full_name       TEXT NOT NULL DEFAULT '',
    avatar_url      TEXT,
    cover_url       TEXT,                                -- Cover photo for profile header
    headline        TEXT,                                -- e.g., "YOGA IN LIFE"
    bio             TEXT,                                -- Short bio/description
    location        TEXT,                                -- e.g., "California, USA"
    follower_count  INTEGER NOT NULL DEFAULT 0,          -- Denormalized counter
    following_count INTEGER NOT NULL DEFAULT 0,          -- Denormalized counter
    role            TEXT NOT NULL DEFAULT 'user' CHECK (role IN ('user', 'admin')),
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Index for username lookups
CREATE INDEX IF NOT EXISTS idx_user_profiles_username ON user_profiles(username);

-- Auto-update updated_at
CREATE TRIGGER update_user_profiles_updated_at
    BEFORE UPDATE ON user_profiles
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- 3. USER_FOLLOWS TABLE (Follow relationships - Junction Table)
-- ============================================================================
-- M:N relationship: USER_PROFILE <-> USER_PROFILE

CREATE TABLE IF NOT EXISTS user_follows (
    follower_id     TEXT NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
    following_id    TEXT NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (follower_id, following_id)
);

-- Indexes for efficient queries
CREATE INDEX IF NOT EXISTS idx_user_follows_follower ON user_follows(follower_id);
CREATE INDEX IF NOT EXISTS idx_user_follows_following ON user_follows(following_id);

-- Prevent self-follow
ALTER TABLE user_follows ADD CONSTRAINT no_self_follow 
    CHECK (follower_id != following_id);

-- ============================================================================
-- 4. TRIGGERS FOR DENORMALIZED COUNTERS
-- ============================================================================

-- Function to update follower/following counts
CREATE OR REPLACE FUNCTION update_follow_counts()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        -- Increment following_count for follower
        UPDATE user_profiles 
        SET following_count = following_count + 1 
        WHERE id = NEW.follower_id;
        
        -- Increment follower_count for followed user
        UPDATE user_profiles 
        SET follower_count = follower_count + 1 
        WHERE id = NEW.following_id;
        
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        -- Decrement following_count for follower
        UPDATE user_profiles 
        SET following_count = GREATEST(0, following_count - 1) 
        WHERE id = OLD.follower_id;
        
        -- Decrement follower_count for unfollowed user
        UPDATE user_profiles 
        SET follower_count = GREATEST(0, follower_count - 1) 
        WHERE id = OLD.following_id;
        
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER trigger_update_follow_counts
    AFTER INSERT OR DELETE ON user_follows
    FOR EACH ROW
    EXECUTE FUNCTION update_follow_counts();

-- ============================================================================
-- 5. ROW LEVEL SECURITY (RLS)
-- ============================================================================

-- Enable RLS
ALTER TABLE auth_users ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_follows ENABLE ROW LEVEL SECURITY;

-- Auth Users Policies
-- Anyone can read (for profile lookup)
CREATE POLICY "auth_users_select" ON auth_users 
    FOR SELECT USING (true);

-- Only owner can update their own record
CREATE POLICY "auth_users_update" ON auth_users 
    FOR UPDATE USING (id = current_setting('request.jwt.claims', true)::json->>'sub');

-- Insert allowed for authenticated users (via service role or matching ID)
CREATE POLICY "auth_users_insert" ON auth_users 
    FOR INSERT WITH CHECK (true);

-- User Profiles Policies
-- Anyone can read profiles
CREATE POLICY "user_profiles_select" ON user_profiles 
    FOR SELECT USING (true);

-- Only owner can update
CREATE POLICY "user_profiles_update" ON user_profiles 
    FOR UPDATE USING (id = current_setting('request.jwt.claims', true)::json->>'sub');

-- Insert allowed for authenticated
CREATE POLICY "user_profiles_insert" ON user_profiles 
    FOR INSERT WITH CHECK (true);

-- User Follows Policies
-- Anyone can read follow relationships
CREATE POLICY "user_follows_select" ON user_follows 
    FOR SELECT USING (true);

-- Only follower can insert/delete
CREATE POLICY "user_follows_insert" ON user_follows 
    FOR INSERT WITH CHECK (
        follower_id = current_setting('request.jwt.claims', true)::json->>'sub'
    );

CREATE POLICY "user_follows_delete" ON user_follows 
    FOR DELETE USING (
        follower_id = current_setting('request.jwt.claims', true)::json->>'sub'
    );

-- ============================================================================
-- 6. HELPER FUNCTION: Create profile after auth_user insert
-- ============================================================================

CREATE OR REPLACE FUNCTION create_profile_for_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO user_profiles (id, full_name, avatar_url)
    VALUES (NEW.id, NEW.full_name, NEW.avatar_url)
    ON CONFLICT (id) DO NOTHING;
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER trigger_create_profile_on_auth_user
    AFTER INSERT ON auth_users
    FOR EACH ROW
    EXECUTE FUNCTION create_profile_for_new_user();

-- ============================================================================
-- DONE! Tables ready for Homies Buddy authentication
-- ============================================================================
