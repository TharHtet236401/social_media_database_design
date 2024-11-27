// Count total number of posts
db.posts.countDocuments();

// Get user statistics including post counts and first/last post dates
db.users.aggregate([
  {
    $lookup: {
      from: "posts",
      localField: "_id",
      foreignField: "user.$id",
      as: "user_posts",
    },
  },
  {
    $project: {
      username: 1,
      user_type: 1,
      post_count: { $size: "$user_posts" },
      first_post_date: { $min: "$user_posts.created_at" },
      last_post_date: { $max: "$user_posts.created_at" },
    },
  },
  {
    $sort: { post_count: -1, username: 1 },
  },
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
      as: "user_posts",
    },
  },
  {
    $lookup: {
      from: "likes",
      localField: "user_posts._id",
      foreignField: "post.$id",
      as: "post_likes",
    },
  },
  {
    $project: {
      username: 1,
      user_type: 1,
      user_id: 1,
      like_count: { $size: "$post_likes" },
    },
  },
  {
    $sort: {
      like_count: -1,
      username: 1,
    },
  },
]);

// Query to show comment counts per user with detailed statistics
db.comments.aggregate([
  // Join with users collection to get user details
  {
    $lookup: {
      from: "users",
      localField: "user.$id",
      foreignField: "_id",
      as: "user_info",
    },
  },
  // Unwind the user_info array since lookup returns an array
  {
    $unwind: "$user_info",
  },
  // Group by user to count comments
  {
    $group: {
      _id: {
        user_id: "$user_info.user_id",
        username: "$user_info.username",
        user_type: "$user_info.user_type",
      },
      total_comments: { $sum: 1 },
      unique_posts: { $addToSet: "$post.$id" },
      first_comment: { $min: "$created_at" },
      last_comment: { $last: "$created_at" },
    },
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
        $round: [
          {
            $divide: [
              "$total_comments",
              {
                $add: [
                  {
                    $divide: [
                      { $subtract: ["$last_comment", "$first_comment"] },
                      1000 * 60 * 60 * 24, // Convert ms to days
                    ],
                  },
                  1, // Add 1 to handle same day comments
                ],
              },
            ],
          },
          2,
        ],
      },
    },
  },
  // Sort by total comments descending, then by username
  {
    $sort: {
      total_comments: -1,
      username: 1,
    },
  },
]);

// Alternative simpler version just showing basic counts
db.comments.aggregate([
  {
    $lookup: {
      from: "users",
      localField: "user.$id",
      foreignField: "_id",
      as: "user_info",
    },
  },
  {
    $unwind: "$user_info",
  },
  {
    $group: {
      _id: {
        username: "$user_info.username",
        user_type: "$user_info.user_type",
      },
      comment_count: { $sum: 1 },
    },
  },
  {
    $project: {
      _id: 0,
      username: "$_id.username",
      user_type: "$_id.user_type",
      comment_count: 1,
    },
  },
  {
    $sort: { comment_count: -1 },
  },
]);

// MongoDB query to find users who sent the most messages
db.messages.aggregate([
  // Join with users collection to get sender details
  {
    $lookup: {
      from: "users",
      localField: "sender.$id",
      foreignField: "_id",
      as: "sender_details",
    },
  },
  // Unwind the sender_details array
  {
    $unwind: "$sender_details",
  },
  // Group by sender and count messages
  {
    $group: {
      _id: {
        username: "$sender_details.username",
        user_type: "$sender_details.user_type",
      },
      message_count: { $sum: 1 },
    },
  },
  // Sort by message count in descending order
  {
    $sort: { message_count: -1 },
  },
  // Project the final output format
  {
    $project: {
      _id: 0,
      username: "$_id.username",
      user_type: "$_id.user_type",
      message_count: 1,
    },
  },
]);

db.messages.countDocuments();

//QUERY 1 for assignment
//the post engagement between 2 dates
db.posts.aggregate([
  // Match posts within the date range and by user type
  {
    $match: {
      created_at: {
        $gte: new Date("2024-03-14T00:00:00Z"),
        $lte: new Date("2024-03-15T23:59:59Z"),
      },
    },
  },
  // Lookup user information for post author
  {
    $lookup: {
      from: "users",
      localField: "user.$id",
      foreignField: "_id",
      as: "author",
    },
  },
  // Filter for regular users only
  {
    $match: {
      "author.user_type": "regular",
    },
  },
  // Lookup likes for the post
  {
    $lookup: {
      from: "likes",
      localField: "_id",
      foreignField: "post.$id",
      as: "likes",
    },
  },
  // Lookup comments for the post
  {
    $lookup: {
      from: "comments",
      localField: "_id",
      foreignField: "post.$id",
      as: "comments",
    },
  },
  // Lookup user information for likes
  {
    $lookup: {
      from: "users",
      localField: "likes.user.$id",
      foreignField: "_id",
      as: "liking_users",
    },
  },
  // Lookup user information for comments
  {
    $lookup: {
      from: "users",
      localField: "comments.user.$id",
      foreignField: "_id",
      as: "commenting_users",
    },
  },
  // Project and calculate fields including engagement_total
  {
    $project: {
      post_id: 1,
      post_author: { $arrayElemAt: ["$author.username", 0] },
      post_content: "$content",
      post_time: "$created_at",
      like_count: { $size: "$likes" },
      comment_count: { $size: "$comments" },
      engagement_total: {
        $add: [{ $size: "$likes" }, { $size: "$comments" }],
      },
      users_who_liked: {
        $reduce: {
          input: {
            $sortArray: {
              input: "$liking_users.username",
              sortBy: 1,
            },
          },
          initialValue: "",
          in: {
            $cond: {
              if: { $eq: ["$$value", ""] },
              then: "$$this",
              else: { $concat: ["$$value", ", ", "$$this"] },
            },
          },
        },
      },
      recent_comments: {
        $reduce: {
          input: {
            $map: {
              input: {
                $sortArray: {
                  input: "$comments",
                  sortBy: { created_at: 1 },
                },
              },
              as: "comment",
              in: {
                $concat: [
                  {
                    $let: {
                      vars: {
                        user: {
                          $arrayElemAt: [
                            {
                              $filter: {
                                input: "$commenting_users",
                                as: "u",
                                cond: {
                                  $eq: ["$$u._id", "$$comment.user.$id"],
                                },
                              },
                            },
                            0,
                          ],
                        },
                      },
                      in: "$$user.username",
                    },
                  },
                  ": ",
                  {
                    $substrCP: ["$$comment.content", 0, 50],
                  },
                ],
              },
            },
          },
          initialValue: "",
          in: {
            $cond: {
              if: { $eq: ["$$value", ""] },
              then: "$$this",
              else: { $concat: ["$$value", " | ", "$$this"] },
            },
          },
        },
      },
    },
  },
  // Filter posts with engagement
  {
    $match: {
      $or: [{ like_count: { $gt: 0 } }, { comment_count: { $gt: 0 } }],
    },
  },
  // Sort by the pre-calculated engagement_total and post_time
  {
    $sort: {
      engagement_total: -1,
      post_time: -1,
    },
  },
]);

// Create necessary indexes
db.posts.createIndex({ created_at: 1 });
db.posts.createIndex({ "user.$id": 1 });
db.likes.createIndex({ "post.$id": 1, "user.$id": 1 });
db.comments.createIndex({ "post.$id": 1, "user.$id": 1 });

// QUERY 2 for assignment
// Query to compare user engagement patterns
// Shows users who are either very active in liking posts or commenting, but not both
db.users.aggregate([
  // First, get all user interactions
  {
    $lookup: {
      from: "likes",
      localField: "_id",
      foreignField: "user.$id",
      as: "user_likes",
    },
  },
  {
    $lookup: {
      from: "comments",
      localField: "_id",
      foreignField: "user.$id",
      as: "user_comments",
    },
  },
  // Calculate like and comment counts
  {
    $project: {
      username: 1,
      user_type: 1,
      like_count: { $size: "$user_likes" },
      comment_count: { $size: "$user_comments" },
    },
  },
  // Filter for users who are either active likers OR active commenters (but not both)
  {
    $match: {
      $or: [
        // Users who frequently like posts (>5 likes) but don't comment much (≤3 comments)
        {
          like_count: { $gt: 5 },
          comment_count: { $lte: 3 },
        },
        // Users who frequently comment (>3 comments) but don't like much (≤5 likes)
        {
          comment_count: { $gt: 3 },
          like_count: { $lte: 5 },
        },
      ],
    },
  },
  // Add engagement type field
  {
    $project: {
      username: 1,
      user_type: 1,
      engagement_count: {
        $cond: {
          if: { $gt: ["$like_count", 5] },
          then: "$like_count",
          else: "$comment_count",
        },
      },
      engagement_type: {
        $cond: {
          if: { $gt: ["$like_count", 5] },
          then: "Primarily Likes Posts",
          else: "Primarily Comments",
        },
      },
    },
  },
  // Sort by username
  {
    $sort: { username: 1 },
  },
]);

// Create indexes to improve performance
db.likes.createIndex({ "user.$id": 1 });
db.comments.createIndex({ "user.$id": 1 });

// Query to see all users with their interests
db.users
  .find(
    { user_type: "regular" },
    {
      username: 1,
      "regular_user.interests": 1,
      _id: 0,
    }
  )
  .sort({ username: 1 });

// Query to count how many users have each interest
db.users.aggregate([
  { $match: { user_type: "regular" } },
  { $unwind: "$regular_user.interests" },
  {
    $group: {
      _id: {
        interest_id: "$regular_user.interests.interest_id",
        interest_name: "$regular_user.interests.interest_name",
      },
      count: { $sum: 1 },
    },
  },
  { $sort: { "_id.interest_id": 1 } },
  {
    $project: {
      _id: 0,
      interest_id: "$_id.interest_id",
      interest_name: "$_id.interest_name",
      user_count: "$count",
    },
  },
]);

// Query to see number of interests per user
db.users.aggregate([
  { $match: { user_type: "regular" } },
  {
    $project: {
      username: 1,
      interest_count: { $size: { $ifNull: ["$regular_user.interests", []] } },
      interests: {
        $reduce: {
          input: "$regular_user.interests",
          initialValue: "",
          in: {
            $concat: [
              "$$value",
              { $cond: [{ $eq: ["$$value", ""] }, "", ", "] },
              "$$this.interest_name",
            ],
          },
        },
      },
    },
  },
  { $sort: { username: 1 } },
]);

//Query 3 for assignment
// Query to see which interests have the most users
db.users.aggregate([
  // Match only regular users
  {
    $match: {
      user_type: "regular",
    },
  },
  // Unwind the interests array to create one document per interest
  {
    $unwind: "$regular_user.interests",
  },
  // Group by interest to count users
  {
    $group: {
      _id: {
        interest_id: "$regular_user.interests.interest_id",
        interest_name: "$regular_user.interests.interest_name",
      },
      num_users: { $sum: 1 },
    },
  },
  // Project the final format
  {
    $project: {
      _id: 0,
      interest_id: "$_id.interest_id",
      interest_name: "$_id.interest_name",
      num_users: 1,
    },
  },
  // Sort by number of users in descending order
  {
    $sort: {
      num_users: -1,
      interest_id: 1,
    },
  },
]);

// Query 4 for assignment
// Temporal query to analyze peak messaging times
db.messages.aggregate([
  // Match messages within the date range
  {
    $match: {
      sent_at: {
        $gte: new Date("2024-03-12T00:00:00Z"),
        $lte: new Date("2024-03-15T23:59:59Z")
      }
    }
  },
  // Add a field for time of day categorization
  {
    $addFields: {
      hour: { $hour: "$sent_at" },
      time_of_day: {
        $switch: {
          branches: [
            {
              case: {
                $and: [
                  { $gte: [{ $hour: "$sent_at" }, 6] },
                  { $lt: [{ $hour: "$sent_at" }, 12] }
                ]
              },
              then: "Morning"
            },
            {
              case: {
                $and: [
                  { $gte: [{ $hour: "$sent_at" }, 12] },
                  { $lt: [{ $hour: "$sent_at" }, 17] }
                ]
              },
              then: "Afternoon"
            },
            {
              case: {
                $and: [
                  { $gte: [{ $hour: "$sent_at" }, 17] },
                  { $lt: [{ $hour: "$sent_at" }, 21] }
                ]
              },
              then: "Evening"
            }
          ],
          default: "Night"
        }
      }
    }
  },
  // Group by time of day to get counts
  {
    $group: {
      _id: "$time_of_day",
      message_count: { $sum: 1 }
    }
  },
  // Calculate total messages for percentage
  {
    $facet: {
      time_periods: [{ $match: {} }],
      total_count: [
        {
          $group: {
            _id: null,
            total: { $sum: "$message_count" }
          }
        }
      ]
    }
  },
  // Unwind and calculate percentages
  {
    $unwind: "$total_count"
  },
  {
    $unwind: "$time_periods"
  },
  {
    $project: {
      _id: 0,
      time_of_day: "$time_periods._id",
      message_count: "$time_periods.message_count",
      percentage_of_total: {
        $round: [
          {
            $multiply: [
              { $divide: ["$time_periods.message_count", "$total_count.total"] },
              100
            ]
          },
          2
        ]
      }
    }
  },
  // Add before the final sort:
]);

//query 5 for assignment
db.posts.aggregate([
    // Match posts within date range and by regular users
    {
        $match: {
            created_at: {
                $gte: new Date("2024-03-12T00:00:00Z"),
                $lte: new Date("2024-03-15T23:59:59Z")
            }
        }
    },
    {
        $lookup: {
            from: "users",
            localField: "user.$id",
            foreignField: "_id",
            as: "user_info"
        }
    },
    {
        $match: {
            "user_info.user_type": "regular"
        }
    },
    // Lookup likes for each post
    {
        $lookup: {
            from: "likes",
            localField: "_id",
            foreignField: "post.$id",
            as: "post_likes"
        }
    },
    // Add fields for date and time period
    {
        $addFields: {
            post_date: {
                $dateToString: { format: "%Y-%m-%d", date: "$created_at" }
            },
            hour: { $hour: "$created_at" },
            time_period: {
                $switch: {
                    branches: [
                        {
                            case: { 
                                $and: [
                                    { $gte: [ { $hour: "$created_at" }, 6 ] },
                                    { $lt: [ { $hour: "$created_at" }, 12 ] }
                                ]
                            },
                            then: "Morning"
                        },
                        {
                            case: { 
                                $and: [
                                    { $gte: [ { $hour: "$created_at" }, 12 ] },
                                    { $lt: [ { $hour: "$created_at" }, 17 ] }
                                ]
                            },
                            then: "Afternoon"
                        },
                        {
                            case: { 
                                $and: [
                                    { $gte: [ { $hour: "$created_at" }, 17 ] },
                                    { $lt: [ { $hour: "$created_at" }, 21 ] }
                                ]
                            },
                            then: "Evening"
                        }
                    ],
                    default: "Night"
                }
            }
        }
    },
    // Group by date and time period with rollup
    {
        $group: {
            _id: {
                post_date: "$post_date",
                time_period: "$time_period"
            },
            total_posts: { $count: {} },
            total_likes: { $sum: { $size: "$post_likes" } }
        }
    },
    // Add calculated fields
    {
        $addFields: {
            avg_likes_per_post: {
                $round: [{
                    $divide: [
                        { $toDouble: "$total_likes" },
                        { $toDouble: "$total_posts" }
                    ]
                }, 2]
            }
        }
    },
    // Generate rollup rows
    {
        $unionWith: {
            coll: "posts",
            pipeline: [
                // Same initial matches and lookups as above
                {
                    $match: {
                        created_at: {
                            $gte: new Date("2024-03-12T00:00:00Z"),
                            $lte: new Date("2024-03-15T23:59:59Z")
                        }
                    }
                },
                {
                    $lookup: {
                        from: "users",
                        localField: "user.$id",
                        foreignField: "_id",
                        as: "user_info"
                    }
                },
                {
                    $match: {
                        "user_info.user_type": "regular"
                    }
                },
                {
                    $lookup: {
                        from: "likes",
                        localField: "_id",
                        foreignField: "post.$id",
                        as: "post_likes"
                    }
                },
                // Group by date only for date rollup
                {
                    $group: {
                        _id: {
                            post_date: { $dateToString: { format: "%Y-%m-%d", date: "$created_at" } },
                            time_period: "All Times"
                        },
                        total_posts: { $count: {} },
                        total_likes: { $sum: { $size: "$post_likes" } }
                    }
                },
                {
                    $addFields: {
                        avg_likes_per_post: {
                            $round: [{
                                $divide: [
                                    { $toDouble: "$total_likes" },
                                    { $toDouble: "$total_posts" }
                                ]
                            }, 2]
                        }
                    }
                }
            ]
        }
    },
    // Add grand total
    {
        $unionWith: {
            coll: "posts",
            pipeline: [
                // Same initial matches and lookups
                {
                    $match: {
                        created_at: {
                            $gte: new Date("2024-03-12T00:00:00Z"),
                            $lte: new Date("2024-03-15T23:59:59Z")
                        }
                    }
                },
                {
                    $lookup: {
                        from: "users",
                        localField: "user.$id",
                        foreignField: "_id",
                        as: "user_info"
                    }
                },
                {
                    $match: {
                        "user_info.user_type": "regular"
                    }
                },
                {
                    $lookup: {
                        from: "likes",
                        localField: "_id",
                        foreignField: "post.$id",
                        as: "post_likes"
                    }
                },
                // Group for grand total
                {
                    $group: {
                        _id: {
                            post_date: "All Dates",
                            time_period: "All Times"
                        },
                        total_posts: { $count: {} },
                        total_likes: { $sum: { $size: "$post_likes" } }
                    }
                },
                {
                    $addFields: {
                        avg_likes_per_post: {
                            $round: [{
                                $divide: [
                                    { $toDouble: "$total_likes" },
                                    { $toDouble: "$total_posts" }
                                ]
                            }, 2]
                        }
                    }
                }
            ]
        }
    },
    // Sort results
    {
        $sort: {
            "_id.post_date": 1,
            "_id.time_period": 1
        }
    },
    // Project final format
    {
        $project: {
            _id: 0,
            post_date: "$_id.post_date",
            time_period: "$_id.time_period",
            total_posts: 1,
            total_likes: 1,
            avg_likes_per_post: 1
        }
    },
    {
      $addFields: {
        sortOrder: {
          $switch: {
            branches: [
              { case: { $eq: ["$time_period", "All Times"] }, then: 0 },
              { case: { $eq: ["$time_period", "Morning"] }, then: 1 },
              { case: { $eq: ["$time_period", "Afternoon"] }, then: 2 },
              { case: { $eq: ["$time_period", "Evening"] }, then: 3 },
              { case: { $eq: ["$time_period", "Night"] }, then: 4 }
            ],
            default: 5
          }
        }
      }
    },
    // Replace the existing sort with:
    {
      $sort: {
        "post_date": 1,  // First sort by date
        "sortOrder": 1   // Then sort by our custom order
      }
    }
]);


