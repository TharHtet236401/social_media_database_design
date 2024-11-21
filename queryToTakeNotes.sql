-- Query to see all users with their basic information
SELECT 
    u.username,
    u.user_type,
    COUNT(p.post_id) as post_count,
    MIN(p.created_at) as first_post_date,
    MAX(p.created_at) as last_post_date
FROM Users u
LEFT JOIN Posts p ON REF(u) = p.user_ref
GROUP BY u.username, u.user_type
ORDER BY post_count DESC, username ASC;


-- Get total post count
SELECT COUNT(*) AS total_posts 
FROM Posts;

--GEt total like count
SELECT COUNT(*) AS total_likes 
FROM Likes;

-- Get total comment count
SELECT COUNT(*) AS total_comments 
FROM Comments;

-- Get total message count
SELECT COUNT(*) AS total_messages 
FROM Messages;

-- Query to get like counts per user
SELECT 
    u.username,
    u.user_type,
    u.user_id,
    COUNT(l.like_id) as like_count
FROM 
    Users u
    LEFT JOIN Posts p ON REF(u) = p.user_ref
    LEFT JOIN Likes l ON REF(p) = l.post_ref
GROUP BY 
    u.username,
    u.user_type
ORDER BY 
    like_count DESC, username ASC;

-- This query retrieves posts with their likes and comments, including user information
-- It shows posts from the last 7 days that have at least 1 like
SELECT DISTINCT
    p.post_id,
    DEREF(p.user_ref).username AS post_author,
    p.content AS post_content,
    p.created_at AS post_date,
    COUNT(DISTINCT l.like_id) AS like_count,
    COUNT(DISTINCT c.comment_id) AS comment_count,
    LISTAGG(DISTINCT DEREF(l.user_ref).username, ', ') 
        WITHIN GROUP (ORDER BY DEREF(l.user_ref).username) AS liking_users
FROM 
    Posts p
    INNER JOIN Likes l ON l.post_ref = REF(p)  -- Inner join to get posts with likes
    LEFT OUTER JOIN Comments c ON c.post_ref = REF(p)  -- Left join to include posts without comments
WHERE 
    p.created_at >= SYSTIMESTAMP - INTERVAL '7' DAY
GROUP BY 
    p.post_id,
    DEREF(p.user_ref).username,
    p.content,
    p.created_at
ORDER BY 
    p.created_at DESC;

-- Query to get comment counts per user (comments made by each user)
SELECT 
    u.username,
    u.user_type,
    COUNT(c.comment_id) as comments_made,
    COUNT(DISTINCT p.post_id) as posts_commented_on,
    MIN(c.created_at) as first_comment_date,
    MAX(c.created_at) as last_comment_date
FROM 
    Users u
    LEFT JOIN Comments c ON REF(u) = c.user_ref
    LEFT JOIN Posts p ON c.post_ref = REF(p)
GROUP BY 
    u.username,
    u.user_type
ORDER BY 
    comments_made DESC, username ASC;

-- Query to get comment counts on each user's posts (comments received by each user)
SELECT 
    DEREF(p.user_ref).username as post_author,
    DEREF(p.user_ref).user_type as author_type,
    COUNT(c.comment_id) as comments_received,
    COUNT(DISTINCT DEREF(c.user_ref).user_id) as unique_commenters,
    COUNT(DISTINCT p.post_id) as posts_with_comments
FROM 
    Posts p
    LEFT JOIN Comments c ON REF(p) = c.post_ref
GROUP BY 
    DEREF(p.user_ref).username,
    DEREF(p.user_ref).user_type
ORDER BY 
    comments_received DESC, post_author ASC;

-- Query to find the most active commenters with detailed statistics
SELECT 
    u.username,
    u.user_type,
    COUNT(c.comment_id) as total_comments,
    COUNT(DISTINCT p.post_id) as unique_posts_commented,
    ROUND(COUNT(c.comment_id) * 100.0 / (SELECT COUNT(*) FROM Comments), 2) as percentage_of_total_comments,
    MIN(c.created_at) as first_comment_date,
    MAX(c.created_at) as last_comment_date,
    ROUND(
        COUNT(c.comment_id) * 1.0 / 
        NULLIF(EXTRACT(DAY FROM MAX(c.created_at) - MIN(c.created_at)), 0), 
        2
    ) as avg_comments_per_day
FROM 
    Users u
    LEFT JOIN Comments c ON REF(u) = c.user_ref
    LEFT JOIN Posts p ON c.post_ref = REF(p)
WHERE 
    c.comment_id IS NOT NULL  -- Only include users who have made comments
GROUP BY 
    u.username,
    u.user_type
ORDER BY 
    total_comments DESC,
    unique_posts_commented DESC;

-- Oracle query to find users who sent the most messages
SELECT 
    u.username,
    u.user_type,
    COUNT(*) as message_count
FROM 
    Users u,
    Messages m
WHERE 
    REF(u) = m.sender_ref
GROUP BY 
    u.username, u.user_type
ORDER BY 
    message_count DESC;

-- This query joins Posts, Likes, Comments and Users tables using different join types
-- It shows posts with their engagement metrics (likes and comments), including user information
-- The query focuses on posts from March 12-15, 2024 with engagement
SELECT DISTINCT 
    p.post_id,
    DEREF(p.user_ref).username AS post_author,
    SUBSTR(p.content, 1, 50) || '...' AS post_preview,  -- Showing first 50 chars for readability
    p.created_at AS post_time,
    COUNT(DISTINCT l.like_id) AS like_count,
    COUNT(DISTINCT c.comment_id) AS comment_count,
    LISTAGG(DISTINCT DEREF(l.user_ref).username, ', ') 
        WITHIN GROUP (ORDER BY DEREF(l.user_ref).username) AS liking_users,
    LISTAGG(DISTINCT DEREF(c.user_ref).username || ': ' || SUBSTR(c.content, 1, 30), ' | ')
        WITHIN GROUP (ORDER BY c.created_at) AS recent_comments
FROM 
    Posts p
    LEFT OUTER JOIN Likes l ON l.post_ref = REF(p)  -- Left join to include posts with no likes
    FULL OUTER JOIN Comments c ON c.post_ref = REF(p)  -- Full join to include all engagement
WHERE 
    p.created_at BETWEEN TIMESTAMP '2024-03-12 00:00:00' 
    AND TIMESTAMP '2024-03-15 23:59:59'
GROUP BY 
    p.post_id,
    DEREF(p.user_ref).username,
    p.content,
    p.created_at
HAVING 
    COUNT(DISTINCT l.like_id) >= 1  -- Posts with at least 1 like
    OR COUNT(DISTINCT c.comment_id) >= 1  -- or at least 1 comment
ORDER BY 
    like_count DESC,
    comment_count DESC,
    p.created_at DESC;



