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


--QUERY 2
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

---
SELECT 
    u.user_id,
    u.username,
    u.email,
    u.user_type,
    u.created_at,
    CASE 
        WHEN VALUE(u) IS OF TYPE (AdminType) THEN
            TREAT(VALUE(u) AS AdminType).admin_level
        ELSE
            NULL
    END as admin_level,
    CASE 
        WHEN VALUE(u) IS OF TYPE (RegularUserType) THEN
            TREAT(VALUE(u) AS RegularUserType).bio
        ELSE
            NULL
    END as bio,
    CASE 
        WHEN VALUE(u) IS OF TYPE (RegularUserType) THEN
            TREAT(VALUE(u) AS RegularUserType).followers
        ELSE
            NULL
    END as followers,
    CASE 
        WHEN VALUE(u) IS OF TYPE (RegularUserType) THEN
            TREAT(VALUE(u) AS RegularUserType).following
        ELSE
            NULL
    END as following
FROM Users u
ORDER BY u.user_id;

-- QueryTesting 2: See regular users with their interests (one row per user-interest combination)
SELECT 
    r.user_id,
    r.username,
    r.email,
    r.bio,
    r.user_status,
    r.followers,
    r.following,
    i.interest_id,
    i.interest_name
FROM Users r, TABLE(TREAT(VALUE(r) AS RegularUserType).interests) i
WHERE VALUE(r) IS OF TYPE (RegularUserType)
ORDER BY r.user_id, i.interest_id;

-- QueryTesting 3: See admin users with their specific attributes
SELECT 
    a.user_id,
    a.username,
    a.email,
    TREAT(VALUE(a) AS AdminType).admin_id,
    TREAT(VALUE(a) AS AdminType).admin_level,
    TREAT(VALUE(a) AS AdminType).report_viewed,
    TREAT(VALUE(a) AS AdminType).last_login
FROM Users a
WHERE VALUE(a) IS OF TYPE (AdminType)
ORDER BY a.user_id;

-- QueryTesting 4: Summary statistics of interests per user
SELECT 
    r.username,
    COUNT(i.interest_id) as interest_count,
    LISTAGG(i.interest_name, ', ') WITHIN GROUP (ORDER BY i.interest_id) as interests
FROM Users r, TABLE(TREAT(VALUE(r) AS RegularUserType).interests) i
WHERE VALUE(r) IS OF TYPE (RegularUserType)
GROUP BY r.username
ORDER BY r.username;

-- Query 5: Count users by type
SELECT 
    user_type,
    COUNT(*) as user_count
FROM Users
GROUP BY user_type
ORDER BY user_type;

-- Simple query to see all users data
SELECT *
FROM Users;

-- Or a more readable format showing user details based on their type
SELECT 
    u.user_id,
    u.username,
    u.email,
    u.user_type,
    u.created_at,
    u.profile_picture,
    CASE 
        WHEN VALUE(u) IS OF TYPE (AdminType) THEN
            'Admin Level: ' || TREAT(VALUE(u) AS AdminType).admin_level || 
            ', Reports: ' || TREAT(VALUE(u) AS AdminType).report_viewed
        WHEN VALUE(u) IS OF TYPE (RegularUserType) THEN
            'Followers: ' || TREAT(VALUE(u) AS RegularUserType).followers || 
            ', Following: ' || TREAT(VALUE(u) AS RegularUserType).following
    END as additional_info,
    CASE 
        WHEN VALUE(u) IS OF TYPE (RegularUserType) THEN
            (
                SELECT LISTAGG(i.interest_name, ', ') WITHIN GROUP (ORDER BY i.interest_id)
                FROM TABLE(TREAT(VALUE(u) AS RegularUserType).interests) i
            )
        ELSE
            NULL
    END as interests
FROM Users u
ORDER BY u.user_id;

-- Query to see how many users have each interest
--Query 3 for testing 
SELECT 
    i.interest_id,
    i.interest_name,
    COUNT(DISTINCT r.user_id) as num_users
FROM Users r,
     TABLE(TREAT(VALUE(r) AS RegularUserType).interests) i
WHERE VALUE(r) IS OF TYPE (RegularUserType)
GROUP BY i.interest_id, i.interest_name
ORDER BY num_users DESC;


-- Query to see users and their interests in a more readable format
SELECT 
    r.username,
    r.user_type,
    COUNT(i.interest_id) as interest_count,
    LISTAGG(i.interest_name, ', ') WITHIN GROUP (ORDER BY i.interest_name) as interests
FROM 
    Users r,
    TABLE(TREAT(VALUE(r) AS RegularUserType).interests) i
WHERE 
    VALUE(r) IS OF TYPE (RegularUserType)
GROUP BY
    r.username,
    r.user_type
ORDER BY 
    r.username;
