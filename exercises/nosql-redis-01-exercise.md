# Redis Key-Value Store Exercise

**Level:** Intermediate  
**Time Estimate:** 20 minutes  
**Prerequisites:** Redis fundamentals, caching patterns, data structures.

## Exercise: Real-time Analytics Dashboard

### Scenario
Build a Redis-based system for a social media platform that tracks:
- User engagement metrics
- Post popularity scores
- Real-time trending topics
- User session management

### Tasks

1. **Data Structure Design**
   - Design Redis data structures for each requirement
   - Choose appropriate data types (strings, hashes, sets, sorted sets)
   - Plan for efficient querying and updates

2. **Session Management**
   - Implement user session storage
   - Handle session expiration
   - Track active users

3. **Engagement Tracking**
   - Track likes, shares, comments per post
   - Calculate popularity scores
   - Implement real-time leaderboards

4. **Trending Topics**
   - Track hashtag usage
   - Calculate trending scores
   - Implement time-based decay

### Sample Implementation
```bash
# User session (Hash)
HSET user:session:123 user_id 123 username "alice" last_active 1640995200

# Post engagement (Hash)
HSET post:456 likes 150 shares 25 comments 8 views 1200

# Popularity leaderboard (Sorted Set)
ZADD posts:popularity 175.5 post:456
ZADD posts:popularity 142.3 post:789

# Trending hashtags (Sorted Set with time decay)
ZADD hashtags:trending 100 #javascript
ZADD hashtags:trending 85 #react
```

### Advanced Challenges
1. **Rate Limiting**: Implement API rate limiting per user
2. **Caching Strategy**: Design cache invalidation for post updates
3. **Pub/Sub**: Implement real-time notifications for trending topics

## Learning Objectives
- Choose appropriate Redis data structures
- Implement real-time analytics
- Design efficient caching strategies
- Handle time-based data and decay
- Build leaderboards and ranking systems
