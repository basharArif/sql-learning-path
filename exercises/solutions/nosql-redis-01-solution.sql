-- Redis Key-Value Store Exercise - Solution
-- Note: This is a Redis exercise, so solutions use Redis commands

-- 1. Data Structure Design
-- User session management using Hash
HSET user:session:123 user_id 123 username "alice" last_active 1640995200 login_time 1640995000
EXPIRE user:session:123 3600  -- Session expires after 1 hour

-- Post engagement metrics using Hash
HSET post:456 likes 150 shares 25 comments 8 views 1200 created_at 1640995200
HINCRBY post:456 likes 1  -- Increment likes when a user likes the post

-- Popularity leaderboard using Sorted Set
ZADD posts:popularity 175.5 post:456
ZADD posts:popularity 142.3 post:789
ZADD posts:popularity 89.2 post:101
ZREVRANGE posts:popularity 0 9 WITHSCORES  -- Get top 10 posts

-- Trending hashtags using Sorted Set with time decay
ZADD hashtags:trending 100 #javascript
ZADD hashtags:trending 85 #react
ZADD hashtags:trending 72 #python
ZREVRANGE hashtags:trending 0 4 WITHSCORES  -- Get top 5 hashtags

-- 2. Session Management
-- Create new session
HSET user:session:456 user_id 456 username "bob" last_active 1640995300 ip_address "192.168.1.10"
EXPIRE user:session:456 1800  -- 30 minute session timeout

-- Get session data
HGETALL user:session:456

-- Update last active time
HSET user:session:456 last_active 1640995400

-- Track active users using Set
SADD active_users 123 456 789
SISMEMBER active_users 123  -- Check if user is active
SCARD active_users  -- Count active users

-- 3. Engagement Tracking
-- Track post interactions
HSET post:789 likes 45 shares 12 comments 5 views 800
HINCRBY post:789 likes 1  -- Increment likes
HINCRBY post:789 views 1  -- Increment view count

-- Calculate engagement score (likes + shares*2 + comments*3)
-- This would typically be done in application code:
-- engagement_score = likes + (shares * 2) + (comments * 3)

-- Real-time leaderboards using Sorted Set
ZADD posts:engagement 205 post:456  -- 45 + (12*2) + (5*3) + (800*0.2)
ZADD posts:engagement 180 post:789
ZREVRANGE posts:engagement 0 9 WITHSCORES  -- Top 10 engaged posts

-- User activity tracking
ZADD user:activity:score 250 user:123
ZADD user:activity:score 180 user:456
ZADD user:activity:score 320 user:789
ZREVRANGE user:activity:score 0 9 WITHSCORES  -- Top active users

-- 4. Trending Topics with time-based decay
-- Function to add hashtag with current timestamp
ZADD hashtags:trending 1640995500 #javascript
ZADD hashtags:trending 1640995450 #react
ZADD hashtags:trending 1640995400 #python

-- Get trending hashtags in the last 24 hours
ZREVRANGEBYSCORE hashtags:trending +inf (1640908800 LIMIT 0 10

-- Decrement scores over time (simulate decay)
ZUNIONSTORE hashtags:trending:temp 2 hashtags:trending neg_scores_weights -0.1 -0.1
ZUNIONSTORE hashtags:trending 2 hashtags:trending hashtags:trending:temp
ZREMRANGEBYSCORE hashtags:trending -inf 10  -- Remove low scoring hashtags

-- 5. Advanced Challenges

-- 1. Rate Limiting: API calls per user
-- Increment counter for user
INCR rate_limit:user:123:request_count
EXPIRE rate_limit:user:123:request_count 3600  -- Reset counter every hour
GET rate_limit:user:123:request_count

-- Check if user exceeded limit (e.g., 100 requests per hour)
-- if GET rate_limit:user:123:request_count > 100 then block user

-- 2. Caching Strategy: Cache for popular posts
-- Cache post content
HMSET post:cache:456 title "How to Learn Redis" author "Alice" content "Redis is a powerful in-memory data store..."
EXPIRE post:cache:456 600  -- Cache expires after 10 minutes

-- Invalidate cache when post is updated
DEL post:cache:456

-- 3. Pub/Sub for real-time notifications
-- Publisher: When hashtag gains momentum
PUBLISH trending_notification "#javascript is trending!"

-- Subscriber: In application to receive notifications
SUBSCRIBE trending_notification

-- Geospatial data for location-based trending (if needed)
GEOADD trending_locations -122.4194 37.7749 "San Francisco" -74.0059 40.7128 "New York"
GEORADIUS trending_locations -122.4194 37.7749 50 km WITHDIST WITHCOORD
</content>