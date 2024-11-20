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
