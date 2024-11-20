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

    