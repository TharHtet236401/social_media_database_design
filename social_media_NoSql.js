// Use the social_media database
use social_media;

// Drop existing collections if they exist
db.users.drop();
db.posts.drop();
db.comments.drop();
db.likes.drop();
db.messages.drop();

// Create collections with schema validation
db.createCollection("users", {
    validator: {
        $jsonSchema: {
            bsonType: "object",
            required: ["username", "email", "password_hash", "created_at", "user_type"],
            properties: {
                username: {
                    bsonType: "string",
                    maxLength: 50
                },
                email: {
                    bsonType: "string",
                    maxLength: 100
                },
                password_hash: {
                    bsonType: "string",
                    maxLength: 255
                },
                created_at: {
                    bsonType: "date"
                },
                profile_picture: {
                    bsonType: "string",
                    maxLength: 500
                },
                user_type: {
                    enum: ["admin", "regular"]
                },
                // Admin specific fields
                admin_id: {
                    bsonType: "number"
                },
                report_viewed: {
                    bsonType: "number"
                },
                last_login: {
                    bsonType: "date"
                },
                admin_level: {
                    bsonType: "number"
                },
                // Regular user specific fields
                bio: {
                    bsonType: "string",
                    maxLength: 4000
                },
                user_status: {
                    bsonType: "string",
                    maxLength: 255
                },
                followers: {
                    bsonType: "number"
                },
                following: {
                    bsonType: "number"
                }
            }
        }
    }
});

// Create indexes
db.users.createIndex({ "username": 1 }, { unique: true });
db.users.createIndex({ "email": 1 }, { unique: true });

// Insert admin users
db.users.insertMany([
    {
        username: "admin_sarah",
        email: "sarah.admin@platform.com",
        password_hash: "hashed_admin_pwd_1",
        created_at: new Date("2023-01-01T09:00:00Z"),
        profile_picture: "admin_profiles/sarah.jpg",
        user_type: "admin",
        admin_id: 1001,
        report_viewed: 250,
        last_login: new Date("2024-03-15T14:30:00Z"),
        admin_level: 1
    },
    {
        username: "admin_michael",
        email: "michael.admin@platform.com",
        password_hash: "hashed_admin_pwd_2",
        created_at: new Date("2023-01-02T10:00:00Z"),
        profile_picture: "admin_profiles/michael.jpg",
        user_type: "admin",
        admin_id: 1002,
        report_viewed: 180,
        last_login: new Date("2024-03-15T16:45:00Z"),
        admin_level: 2
    },
    {
        username: "admin_jessica",
        email: "jessica.admin@platform.com",
        password_hash: "hashed_admin_pwd_3",
        created_at: new Date("2023-01-03T11:00:00Z"),
        profile_picture: "admin_profiles/jessica.jpg",
        user_type: "admin",
        admin_id: 1003,
        report_viewed: 320,
        last_login: new Date("2024-03-15T15:20:00Z"),
        admin_level: 1
    },
    {
        username: "admin_david",
        email: "david.admin@platform.com",
        password_hash: "hashed_admin_pwd_4",
        created_at: new Date("2023-01-04T12:00:00Z"),
        profile_picture: "admin_profiles/david.jpg",
        user_type: "admin",
        admin_id: 1004,
        report_viewed: 290,
        last_login: new Date("2024-03-15T17:10:00Z"),
        admin_level: 2
    },
    {
        username: "admin_emma",
        email: "emma.admin@platform.com",
        password_hash: "hashed_admin_pwd_5",
        created_at: new Date("2023-01-05T13:00:00Z"),
        profile_picture: "admin_profiles/emma.jpg",
        user_type: "admin",
        admin_id: 1005,
        report_viewed: 275,
        last_login: new Date("2024-03-15T18:00:00Z"),
        admin_level: 1
    }
]);

// Insert regular users
db.users.insertMany([
    {
        username: "tech_guru_alex",
        email: "alex@email.com",
        password_hash: "hashed_pwd_1",
        created_at: new Date("2023-02-01T10:00:00Z"),
        profile_picture: "profiles/alex.jpg",
        user_type: "regular",
        bio: "Software Developer | AI Enthusiast | Coffee Lover",
        user_status: "Coding something cool",
        followers: 15,
        following: 12
    },
    {
        username: "fitness_jane",
        email: "jane@email.com",
        password_hash: "hashed_pwd_2",
        created_at: new Date("2023-02-02T11:00:00Z"),
        profile_picture: "profiles/jane.jpg",
        user_type: "regular",
        bio: "Personal Trainer | Nutrition Expert",
        user_status: "At the gym 💪",
        followers: 18,
        following: 15
    }
    // ... Continue with the rest of the regular users following the same pattern
]);

// Create other collections
