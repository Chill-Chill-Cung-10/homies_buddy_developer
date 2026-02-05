# WARNING: THIS IS WHAT I'M THINKING OF, IF YOU HAVE SUGGEST TO IMPORVE, NOT IMPLEMENT CODE, TELL ME YOUR PLAN, AND DO IT AFTER I VERIFY TIT

# In Community Tab, I want to focus on some models:

## Firstly, it is props for Post
- authorName : string 
- authorId: string
- authorAvatar: string
- postId: string
- createdAt: DateTime
- updatedAt?: DateTime
- contentText: string
- hashtags: List<string>
- mentions: List<string>
- mediaFiles: List<MediaFile> // Link cdn
- reactsCount: int
- commentCount: int
- isLikedByMe: boolean
- privacy: "public" | "friends" | "private"

Sub-class for Post props:
**mediaFile**:
- id: string
- thumbnailUrl?: string
- mediaType: "image" | "video" | "album"
- mediaAspectRatio: float
- mediaUrl: string
- width: int
- height: int
- durationSeconds?: int

## Secondly, it is props for Notification
- actorId: string
- actorName: string
- actorAvatar: string
- notificationId: string
- type: "react" | "comment"
- createdAt: DateTime
- isRead: boolean
- postId: string
- commentId?: string
- deepLink: string
- contentPreview?: string

## Thirdly, it is props for Comment
- commentId: string
- postId: string
- authorId: string
- authorName: string
- authorAvatar: string
- contentText: string
- createdAt: DateTime
- updatedAt?: DateTime
- reactCount: int
- isReactedByMe: bool

## Fourthly, when user click on pet profile, props for PetProfile

- petId: string
- petName: string
- petAvatar: string
- petOwner: PetOwner
- petPitching: string
- isFollowedByMe: bool
- followerCount: int

PetOwner:
- ownerId: string
- ownerName: string
- ownerAvatar: string
 
