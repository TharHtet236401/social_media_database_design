// Count total number of posts
db.posts.countDocuments();

// Get user statistics including post counts and first/last post dates
db.users.aggregate([
    {
        $lookup: {
            from: "posts",
            localField: "_id",
            foreignField: "user.$id",
            as: "user_posts"
        }
    },
    {
        $project: {
            username: 1,
            user_type: 1,
            post_count: { $size: "$user_posts" },
            first_post_date: { $min: "$user_posts.created_at" },
            last_post_date: { $max: "$user_posts.created_at" }
        }
    },
    {
        $sort: { post_count: -1 ,username: 1}

    }
]);

// Get total like count
    db.likes.countDocuments();

    // Get like counts per user
    db.users.aggregate([
        {
            $lookup: {
                from: "posts",
                localField: "_id",
                foreignField: "user.$id",
                as: "user_posts"
            }
        },
        {
            $lookup: {
                from: "likes",
                localField: "user_posts._id",
                foreignField: "post.$id",
                as: "post_likes"
            }
        },
        {
            $project: {
                username: 1,
                user_type: 1,
                user_id: 1,
                like_count: { $size: "$post_likes" }
            }
        },
        {
            $sort: {
                like_count: -1,
                username: 1
            }
        }
    ]);

// Query to show comment counts per user with detailed statistics
db.comments.aggregate([
    // Join with users collection to get user details
    {
        $lookup: {
            from: "users",
            localField: "user.$id",
            foreignField: "_id",
            as: "user_info"
        }
    },
    // Unwind the user_info array since lookup returns an array
    {
        $unwind: "$user_info"
    },
    // Group by user to count comments
    {
        $group: {
            _id: {
                user_id: "$user_info.user_id",
                username: "$user_info.username",
                user_type: "$user_info.user_type"
            },
            total_comments: { $sum: 1 },
            unique_posts: { $addToSet: "$post.$id" },
            first_comment: { $min: "$created_at" },
            last_comment: { $last: "$created_at" }
        }
    },
    // Add calculated fields
    {
        $project: {
            _id: 0,
            username: "$_id.username",
            user_type: "$_id.user_type",
            total_comments: 1,
            unique_posts_commented: { $size: "$unique_posts" },
            first_comment_date: "$first_comment",
            last_comment_date: "$last_comment",
            // Calculate average comments per day
            avg_comments_per_day: {
                $round: [{
                    $divide: [
                        "$total_comments",
                        {
                            $add: [
                                {
                                    $divide: [
                                        { $subtract: ["$last_comment", "$first_comment"] },
                                        1000 * 60 * 60 * 24 // Convert ms to days
                                    ]
                                },
                                1 // Add 1 to handle same day comments
                            ]
                        }
                    ]
                }, 2]
            }
        }
    },
    // Sort by total comments descending, then by username
    {
        $sort: {
            total_comments: -1,
            username: 1
        }
    }
]);

// Alternative simpler version just showing basic counts
db.comments.aggregate([
    {
        $lookup: {
            from: "users",
            localField: "user.$id",
            foreignField: "_id",
            as: "user_info"
        }
    },
    {
        $unwind: "$user_info"
    },
    {
        $group: {
            _id: {
                username: "$user_info.username",
                user_type: "$user_info.user_type"
            },
            comment_count: { $sum: 1 }
        }
    },
    {
        $project: {
            _id: 0,
            username: "$_id.username",
            user_type: "$_id.user_type",
            comment_count: 1
        }
    },
    {
        $sort: { comment_count: -1 }
    }
]);

// MongoDB query to find users who sent the most messages
db.messages.aggregate([
    // Join with users collection to get sender details
    {
        $lookup: {
            from: "users",
            localField: "sender.$id",
            foreignField: "_id",
            as: "sender_details"
        }
    },
    // Unwind the sender_details array
    {
        $unwind: "$sender_details"
    },
    // Group by sender and count messages
    {
        $group: {
            _id: {
                username: "$sender_details.username",
                user_type: "$sender_details.user_type"
            },
            message_count: { $sum: 1 }
        }
    },
    // Sort by message count in descending order
    {
        $sort: { message_count: -1 }
    },
    // Project the final output format
    {
        $project: {
            _id: 0,
            username: "$_id.username",
            user_type: "$_id.user_type",
            message_count: 1
        }
    }
]);

db.messages.countDocuments();

// Query to get posts with engagement metrics and details
db.posts.aggregate([
    // Match posts within date range
    {
        $match: {
            created_at: {
                $gte: new Date("2024-03-12T00:00:00Z"),
                $lte: new Date("2024-03-15T23:59:59Z")
            }
        }
    },
    // Lookup user information for post author
    {
        $lookup: {
            from: "users",
            localField: "user.$id",
            foreignField: "_id",
            as: "author"
        }
    },
    // Lookup likes for the post
    {
        $lookup: {
            from: "likes",
            localField: "_id",
            foreignField: "post.$id",
            as: "likes"
        }
    },
    // Lookup comments for the post
    {
        $lookup: {
            from: "comments",
            localField: "_id",
            foreignField: "post.$id",
            as: "comments"
        }
    },
    // Lookup user information for likes
    {
        $lookup: {
            from: "users",
            localField: "likes.user.$id",
            foreignField: "_id",
            as: "liking_users"
        }
    },
    // Project the final format
    {
        $project: {
            post_id: "$_id",
            post_author: { $arrayElemAt: ["$author.username", 0] },
            post_preview: {
                $concat: [
                    { 
                        $substrCP: [
                            { $ifNull: ["$content", ""] },
                            0,
                            50
                        ]
                    },
                    "..."
                ]
            },
            post_time: "$created_at",
            like_count: { $size: "$likes" },
            comment_count: { $size: "$comments" },
            liking_users: {
                $map: {
                    input: "$liking_users",
                    as: "user",
                    in: "$$user.username"
                }
            },
            recent_comments: {
                $map: {
                    input: {
                        $slice: [{
                            $sortArray: {
                                input: "$comments",
                                sortBy: { created_at: 1 }
                            }
                        }, 5]
                    },
                    as: "comment",
                    in: {
                        username: "$$comment.user.username",
                        preview: {
                            $concat: [
                                {
                                    $substrCP: [
                                        { $ifNull: ["$$comment.content", ""] },
                                        0,
                                        30
                                    ]
                                },
                                "..."
                            ]
                        }
                    }
                }
            }
        }
    },
    // Match posts that have either likes or comments
    {
        $match: {
            $or: [
                { like_count: { $gte: 1 } },
                { comment_count: { $gte: 1 } }
            ]
        }
    },
    // Sort by engagement metrics
    {
        $sort: {
            like_count: -1,
            comment_count: -1,
            post_time: -1
        }
    }
]);


