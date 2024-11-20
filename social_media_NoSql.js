// Use the social_media database
use("social_media");

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
                admin_user:{
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
                },
                // Regular user specific fields
                regular_user:{
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
        admin_user:{
            admin_id: 1001,
            report_viewed: 250,
            last_login: new Date("2024-03-15T14:30:00Z"),
            admin_level: 1
        }
    },
    {
        username: "admin_michael",
        email: "michael.admin@platform.com",
        password_hash: "hashed_admin_pwd_2",
        created_at: new Date("2023-01-02T10:00:00Z"),
        profile_picture: "admin_profiles/michael.jpg",
        user_type: "admin",
        admin_user:{
            admin_id: 1002,
            report_viewed: 180,
            last_login: new Date("2024-03-15T16:45:00Z"),
            admin_level: 2
        }
    },
    {
        username: "admin_jessica",
        email: "jessica.admin@platform.com",
        password_hash: "hashed_admin_pwd_3",
        created_at: new Date("2023-01-03T11:00:00Z"),
        profile_picture: "admin_profiles/jessica.jpg",
        user_type: "admin",
        admin_user:{
            admin_id: 1003,
            report_viewed: 320,
            last_login: new Date("2024-03-15T15:20:00Z"),
            admin_level: 1
        }
    },
    {
        username: "admin_david",
        email: "david.admin@platform.com",
        password_hash: "hashed_admin_pwd_4",
        created_at: new Date("2023-01-04T12:00:00Z"),
        profile_picture: "admin_profiles/david.jpg",
        user_type: "admin",
        admin_user:{
            admin_id: 1004,
            report_viewed: 290,
            last_login: new Date("2024-03-15T17:10:00Z"),
            admin_level: 2
        }
    },
    {
        username: "admin_emma",
        email: "emma.admin@platform.com",
        password_hash: "hashed_admin_pwd_5",
        created_at: new Date("2023-01-05T13:00:00Z"),
        profile_picture: "admin_profiles/emma.jpg",
        user_type: "admin",
        admin_user:{
            admin_id: 1005,
            report_viewed: 275,
            last_login: new Date("2024-03-15T18:00:00Z"),
            admin_level: 1
        }
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
        regular_user:{
            bio: "Software Developer | AI Enthusiast | Coffee Lover",
            user_status: "Coding something cool",
            followers: 15,
            following: 12
        }
    },
    {
        username: "fitness_jane",
        email: "jane@email.com",
        password_hash: "hashed_pwd_2",
        created_at: new Date("2023-02-02T11:00:00Z"),
        profile_picture: "profiles/jane.jpg",
        user_type: "regular",
        regular_user:{
            bio: "Personal Trainer | Nutrition Expert",
            user_status: "At the gym 💪",
            followers: 18,
            following: 15
        }
    },
    {
        username: "foodie_mark",
        email: "mark@email.com",
        password_hash: "hashed_pwd_3",
        created_at: new Date("2023-02-03T12:00:00Z"),
        profile_picture: "profiles/mark.jpg",
        user_type: "regular",
        regular_user:{
            bio: "Food Blogger | Chef | Restaurant Explorer",
            user_status: "Cooking up something special",
            followers: 20,
            following: 17
        }
    },
    {
        username: "artist_lisa",
        email: "lisa@email.com",
        password_hash: "hashed_pwd_4",
        created_at: new Date("2023-02-04T13:00:00Z"),
        profile_picture: "profiles/lisa.jpg",
        user_type: "regular",
        regular_user:{
            bio: "Digital Artist | Illustrator",
            user_status: "Creating new artwork",
            followers: 16,
            following: 14
        }
    },
    {
        username: "travel_mike",
        email: "mike@email.com",
        password_hash: "hashed_pwd_5",
        created_at: new Date("2023-02-05T14:00:00Z"),
        profile_picture: "profiles/mike.jpg",
        user_type: "regular",
        regular_user:{
            bio: "World Traveler | Photographer",
            user_status: "Exploring new places",
            followers: 19,
            following: 16
        }
    },
    {
        username: "gamer_sam",
        email: "sam@email.com",
        password_hash: "hashed_pwd_6",
        created_at: new Date("2023-02-06T15:00:00Z"),
        profile_picture: "profiles/sam.jpg",
        user_type: "regular",
        regular_user:{
            bio: "Professional Gamer | Streamer",
            user_status: "Live streaming now!",
            followers: 20,
            following: 18
        }
    },
    {
        username: "music_rachel",
        email: "rachel@email.com",
        password_hash: "hashed_pwd_7",
        created_at: new Date("2023-02-07T16:00:00Z"),
        profile_picture: "profiles/rachel.jpg",
        user_type: "regular",
        regular_user:{
            bio: "Singer | Songwriter | Producer",
            user_status: "Making music 🎵",
            followers: 17,
            following: 15
        }
    },
    {
        username: "eco_peter",
        email: "peter@email.com",
        password_hash: "hashed_pwd_8",
        created_at: new Date("2023-02-08T17:00:00Z"),
        profile_picture: "profiles/peter.jpg",
        user_type: "regular",
        regular_user:{
            bio: "Environmental Activist | Sustainable Living",
            user_status: "Saving the planet 🌍",
            followers: 14,
            following: 12
        }
    },
    {
        username: "fashion_nina",
        email: "nina@email.com",
        password_hash: "hashed_pwd_9",
        created_at: new Date("2023-02-09T18:00:00Z"),
        profile_picture: "profiles/nina.jpg",
        user_type: "regular",
        regular_user:{
            bio: "Fashion Blogger | Style Consultant",
            user_status: "Fashion week ready",
            followers: 20,
            following: 16
        }
    },
    {
        username: "chef_carlos",
        email: "carlos@email.com",
        password_hash: "hashed_pwd_10",
        created_at: new Date("2023-02-10T19:00:00Z"),
        profile_picture: "profiles/carlos.jpg",
        user_type: "regular",
        regular_user:{
            bio: "Professional Chef | Food Photography",
            user_status: "In the kitchen",
            followers: 18,
            following: 15
        }
    },
    {
        username: "yoga_emma",
        email: "emma.y@email.com",
        password_hash: "hashed_pwd_11",
        created_at: new Date("2023-02-11T20:00:00Z"),
        profile_picture: "profiles/emma_y.jpg",
        user_type: "regular",
        regular_user:{
            bio: "Yoga Instructor | Mindfulness Coach",
            user_status: "Namaste 🧘‍♀️",
            followers: 16,
            following: 13
        }
    },
    {
        username: "photographer_tom",
        email: "tom@email.com",
        password_hash: "hashed_pwd_12",
        created_at: new Date("2023-02-12T21:00:00Z"),
        profile_picture: "profiles/tom.jpg",
        user_type: "regular",   
        regular_user:{
            bio: "Professional Photographer | Nature Lover",
            user_status: "Capturing moments",
            followers: 19,
            following: 17
        }
    },
    {
        username: "writer_sophia",
        email: "sophia@email.com",
        password_hash: "hashed_pwd_13",
        created_at: new Date("2023-02-13T22:00:00Z"),
        profile_picture: "profiles/sophia.jpg",
        user_type: "regular",
        regular_user:{
            bio: "Author | Book Reviewer | Coffee Addict",
            user_status: "Writing my next novel",
            followers: 15,
            following: 14
        }
    },
    {
        username: "startup_ryan",
        email: "ryan@email.com",
        password_hash: "hashed_pwd_14",
        created_at: new Date("2023-02-14T23:00:00Z"),
        profile_picture: "profiles/ryan.jpg",
        user_type: "regular",
        regular_user:{
            bio: "Entrepreneur | Tech Startup Founder",
            user_status: "Building the future",
            followers: 20,
            following: 15
        }
    },
    {
        username: "dancer_maria",
        email: "maria@email.com",
        password_hash: "hashed_pwd_15",
        created_at: new Date("2023-02-15T00:00:00Z"),
        profile_picture: "profiles/maria.jpg",
        user_type: "regular",
        regular_user:{
            bio: "Professional Dancer | Dance Instructor",
            user_status: "Dancing through life 💃",
            followers: 18,
            following: 16
        }
    },
    {
        username: "scientist_alan",
        email: "alan@email.com",
        password_hash: "hashed_pwd_16",
        created_at: new Date("2023-02-16T01:00:00Z"),
        profile_picture: "profiles/alan.jpg",
        user_type: "regular",   
        regular_user:{
            bio: "Research Scientist | Physics Enthusiast",
            user_status: "Exploring the universe",
            followers: 13,
            following: 11
        }
    },
    {
        username: "diy_hannah",
        email: "hannah@email.com",
        password_hash: "hashed_pwd_17",
        created_at: new Date("2023-02-17T02:00:00Z"),
        profile_picture: "profiles/hannah.jpg",
        user_type: "regular",
        regular_user:{
            bio: "DIY Expert | Home Improvement",
            user_status: "Creating something new",
            followers: 17,
            following: 14
        }
    },
    {
        username: "comedian_jack",
        email: "jack@email.com",
        password_hash: "hashed_pwd_18",
        created_at: new Date("2023-02-18T03:00:00Z"),
        profile_picture: "profiles/jack.jpg",
        user_type: "regular",
        regular_user:{
            bio: "Stand-up Comedian | Content Creator",
            user_status: "Making people laugh 😂",
            followers: 20,
            following: 18
        }
    },
    {
        username: "pet_lover_lucy",
        email: "lucy@email.com",
        password_hash: "hashed_pwd_19",
        created_at: new Date("2023-02-19T04:00:00Z"),
        profile_picture: "profiles/lucy.jpg",
        user_type: "regular",
        regular_user:{
            bio: "Pet Influencer | Animal Rescue Advocate",
            user_status: "Playing with puppies 🐕",
            followers: 19,
            following: 16
        }
    },
    {
        username: "sports_coach_ben",
        email: "ben@email.com",
        password_hash: "hashed_pwd_20",
        created_at: new Date("2023-02-20T05:00:00Z"),
        profile_picture: "profiles/ben.jpg",
        user_type: "regular",
        regular_user:{
            bio: "Sports Coach | Fitness Expert",
            user_status: "Training champions",
            followers: 17,
            following: 15
        }
    }
]);

// Create other collections
