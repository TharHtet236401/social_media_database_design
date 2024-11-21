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



--to see all posts with likes
SELECT 
    p.post_id,
    DEREF(p.user_ref).username AS author,
    p.content,
    p.created_at,
    COUNT(l.like_id) AS like_count,
FROM 
    Posts p
    RIGHT OUTER JOIN Likes l ON l.post_ref = REF(p)
GROUP BY
    p.post_id,
    DEREF(p.user_ref).username,
    p.content, 
    p.created_at
ORDER BY 
    like_count DESC,
    p.created_at DESC;


--new query with all joins 
-- QUERY 1
-- posts engagement between 14 and 15 march 2024
SELECT 
    p.post_id,
    DEREF(p.user_ref).username AS post_author,
    p.content AS post_content,
    p.created_at AS post_time,
    COUNT(DISTINCT l.like_id) AS like_count,
    COUNT(DISTINCT c.comment_id) AS comment_count,
    COUNT(DISTINCT l.like_id) + COUNT(DISTINCT c.comment_id) AS engagement_total,
    
    LISTAGG(DISTINCT DEREF(l.user_ref).username, ', ') 
        WITHIN GROUP (ORDER BY DEREF(l.user_ref).username) AS users_who_liked,
    LISTAGG(DISTINCT DEREF(c.user_ref).username || ': ' || SUBSTR(c.content, 1, 50), ' | ')
        WITHIN GROUP (ORDER BY c.created_at) AS recent_comments
FROM 
    Posts p
    INNER JOIN Users u ON REF(u) = p.user_ref  -- Get post authors
    RIGHT OUTER JOIN Likes l ON l.post_ref = REF(p)  -- Exclude posts with no likes
    FULL OUTER JOIN Comments c ON c.post_ref = REF(p)  -- Include all engagement
WHERE 
    p.created_at BETWEEN TIMESTAMP '2024-03-14 00:00:00' 
    AND TIMESTAMP '2024-03-15 23:59:59'
    AND (
        DEREF(p.user_ref).user_type = 'regular'  
    )
GROUP BY 
    p.post_id,
    DEREF(p.user_ref).username,
    p.content,
    p.created_at
HAVING 
    COUNT(DISTINCT l.like_id) > 0  
    OR COUNT(DISTINCT c.comment_id) > 0
ORDER BY 
    engagement_total DESC,  
    p.created_at DESC;

-- Query to compare user engagement patterns using set operators
-- Shows users who are either very active in liking posts or commenting, but not both
-- This helps identify users with distinct engagement preferences

-- Users who frequently like posts (more than 5 likes)
SELECT 
    DEREF(l.user_ref).username AS username,
    DEREF(l.user_ref).user_type AS user_type,
    COUNT(l.like_id) AS engagement_count,
    'Primarily Likes Posts' AS engagement_type
FROM 
    Likes l
GROUP BY 
    DEREF(l.user_ref).username,
    DEREF(l.user_ref).user_type
HAVING 
    COUNT(l.like_id) > 5

MINUS

-- Remove users who are also active commenters
SELECT 
    DEREF(c.user_ref).username,
    DEREF(c.user_ref).user_type,
    COUNT(c.comment_id),
    'Primarily Likes Posts'
FROM 
    Comments c
GROUP BY 
    DEREF(c.user_ref).username,
    DEREF(c.user_ref).user_type
HAVING 
    COUNT(c.comment_id) > 3

UNION

-- Users who frequently comment (more than 3 comments)
SELECT 
    DEREF(c.user_ref).username AS username,
    DEREF(c.user_ref).user_type AS user_type,
    COUNT(c.comment_id) AS engagement_count,
    'Primarily Comments' AS engagement_type
FROM 
    Comments c
GROUP BY 
    DEREF(c.user_ref).username,
    DEREF(c.user_ref).user_type
HAVING 
    COUNT(c.comment_id) > 3

MINUS

-- Remove users who are also active likers
SELECT 
    DEREF(l.user_ref).username,
    DEREF(l.user_ref).user_type,
    COUNT(l.like_id),
    'Primarily Comments'
FROM 
    Likes l
GROUP BY 
    DEREF(l.user_ref).username,
    DEREF(l.user_ref).user_type
HAVING 
    COUNT(l.like_id) > 5

ORDER BY 
    username ASC;

-- Query to identify different user behavior patterns using INTERSECT and UNION
-- Compares content creators vs engagers and finds interesting user segments

-- Active content creators (users with multiple posts in last 30 days)
SELECT 
    DEREF(p.user_ref).username AS username,
    DEREF(p.user_ref).user_type AS user_type,
    COUNT(p.post_id) AS activity_count,
    CAST('Active Creator' AS VARCHAR2(20)) AS behavior_type
FROM 
    Posts p
WHERE 
    p.created_at >= SYSTIMESTAMP - INTERVAL '30' DAY
GROUP BY 
    DEREF(p.user_ref).username,
    DEREF(p.user_ref).user_type
HAVING 
    COUNT(p.post_id) >= 3

INTERSECT

-- Active engagers (users who both like and comment frequently)
SELECT 
    u.username,
    u.user_type,
    COUNT(DISTINCT l.like_id) + COUNT(DISTINCT c.comment_id),
    CAST('Active Creator' AS VARCHAR2(20))
FROM 
    Users u
    LEFT JOIN Likes l ON REF(u) = l.user_ref
    LEFT JOIN Comments c ON REF(u) = c.user_ref
WHERE 
    l.created_at >= SYSTIMESTAMP - INTERVAL '30' DAY
    OR c.created_at >= SYSTIMESTAMP - INTERVAL '30' DAY
GROUP BY 
    u.username,
    u.user_type
HAVING 
    COUNT(DISTINCT l.like_id) >= 5
    AND COUNT(DISTINCT c.comment_id) >= 3

UNION

-- Silent creators (users who post but rarely engage)
SELECT 
    DEREF(p.user_ref).username,
    DEREF(p.user_ref).user_type,
    COUNT(p.post_id),
    CAST('Silent Creator' AS VARCHAR2(20))
FROM 
    Posts p
    LEFT JOIN Likes l ON l.user_ref = p.user_ref
    LEFT JOIN Comments c ON c.user_ref = p.user_ref
WHERE 
    p.created_at >= SYSTIMESTAMP - INTERVAL '30' DAY
GROUP BY 
    DEREF(p.user_ref).username,
    DEREF(p.user_ref).user_type
HAVING 
    COUNT(p.post_id) >= 3
    AND COUNT(l.like_id) + COUNT(c.comment_id) <= 2

ORDER BY 
    behavior_type,
    activity_count DESC,
    username;


