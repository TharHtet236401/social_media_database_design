// Use the social_media database
use("social_media");

// Drop existing collections if they exist
db.users.drop();
db.posts.drop();
db.comments.drop();
db.likes.drop();
db.messages.drop();

//Create collections with schema validation
db.createCollection("users", {
    validator: {
        $jsonSchema: {
            bsonType: "object",
            required: ["user_id", "username", "email", "password_hash", "created_at", "user_type"],
            properties: {
                user_id: {
                    bsonType: "number"
                },
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
                    bsonType: "string",
                    enum: ["admin", "regular"]
                },
                admin_user: {
                    bsonType: "object",
                    properties: {
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
                        }
                    }
                },
                regular_user: {
                    bsonType: "object",
                    properties: {
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
        }
    }
});

// Create indexes
db.users.createIndex({ "user_id": 1 }, { unique: true });
db.users.createIndex({ "email": 1 }, { unique: true });

// Insert admin users
db.users.insertMany([
    {
        user_id: 1001,
        username: "admin_sarah",
        email: "sarah.admin@platform.com",
        password_hash: "hashed_admin_pwd_1",
        created_at: new Date("2023-01-01T09:00:00Z"),
        profile_picture: "admin_profiles/sarah.jpg",
        user_type: "admin",
        admin_user:{
            admin_id: 5001,
            report_viewed: 250,
            last_login: new Date("2024-03-15T14:30:00Z"),
            admin_level: 1
        }
    },
    {
        user_id: 1002,
        username: "admin_michael",
        email: "michael.admin@platform.com",
        password_hash: "hashed_admin_pwd_2",
        created_at: new Date("2023-01-02T10:00:00Z"),
        profile_picture: "admin_profiles/michael.jpg",
        user_type: "admin",
        admin_user:{
            admin_id: 5002,
            report_viewed: 180,
            last_login: new Date("2024-03-15T16:45:00Z"),
            admin_level: 2
        }
    },
    {
        user_id: 1003,
        username: "admin_jessica",
        email: "jessica.admin@platform.com",
        password_hash: "hashed_admin_pwd_3",
        created_at: new Date("2023-01-03T11:00:00Z"),
        profile_picture: "admin_profiles/jessica.jpg",
        user_type: "admin",
        admin_user:{
            admin_id: 5003,
            report_viewed: 320,
            last_login: new Date("2024-03-15T15:20:00Z"),
            admin_level: 1
        }
    },
    {
        user_id: 1004,
        username: "admin_david",
        email: "david.admin@platform.com",
        password_hash: "hashed_admin_pwd_4",
        created_at: new Date("2023-01-04T12:00:00Z"),
        profile_picture: "admin_profiles/david.jpg",
        user_type: "admin",
        admin_user:{
            admin_id: 5004,
            report_viewed: 290,
            last_login: new Date("2024-03-15T17:10:00Z"),
            admin_level: 2
        }
    },
    {
        user_id: 1005,
        username: "admin_emma",
        email: "emma.admin@platform.com",
        password_hash: "hashed_admin_pwd_5",
        created_at: new Date("2023-01-05T13:00:00Z"),
        profile_picture: "admin_profiles/emma.jpg",
        user_type: "admin",
        admin_user:{
            admin_id: 5005,
            report_viewed: 275,
            last_login: new Date("2024-03-15T18:00:00Z"),
            admin_level: 1
        }
    }
]);
// Insert regular users
db.users.insertMany([
    {
        user_id: 1006,
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
        user_id: 1007,
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
        user_id: 1008,
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
        user_id: 1009,
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
        user_id: 1010,
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
        user_id: 1011,
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
        user_id: 1012,
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
        user_id: 1013,
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
        user_id: 1014,
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
        user_id: 1015,
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
        user_id: 1016,
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
        user_id: 1017,
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
        user_id: 1018,
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
        user_id: 1019,
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
        user_id: 1020,
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
        user_id: 1021,
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
        user_id: 1022,
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
        user_id: 1023,
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
        user_id: 1024,
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
        user_id: 1025,
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

// First get all user references that we'll need
var user_1006_id = db.users.find({ user_id: { $eq: 1006 }}).toArray()[0]._id;
var user_1007_id = db.users.find({ user_id: { $eq: 1007 }}).toArray()[0]._id;
var user_1008_id = db.users.find({ user_id: { $eq: 1008 }}).toArray()[0]._id;
var user_1009_id = db.users.find({ user_id: { $eq: 1009 }}).toArray()[0]._id;
var user_1010_id = db.users.find({ user_id: { $eq: 1010 }}).toArray()[0]._id;
var user_1011_id = db.users.find({ user_id: { $eq: 1011 }}).toArray()[0]._id;
var user_1012_id = db.users.find({ user_id: { $eq: 1012 }}).toArray()[0]._id;
var user_1013_id = db.users.find({ user_id: { $eq: 1013 }}).toArray()[0]._id;
var user_1014_id = db.users.find({ user_id: { $eq: 1014 }}).toArray()[0]._id;
var user_1015_id = db.users.find({ user_id: { $eq: 1015 }}).toArray()[0]._id;
var user_1016_id = db.users.find({ user_id: { $eq: 1016 }}).toArray()[0]._id;
var user_1017_id = db.users.find({ user_id: { $eq: 1017 }}).toArray()[0]._id;
var user_1018_id = db.users.find({ user_id: { $eq: 1018 }}).toArray()[0]._id;
var user_1019_id = db.users.find({ user_id: { $eq: 1019 }}).toArray()[0]._id;
var user_1020_id = db.users.find({ user_id: { $eq: 1020 }}).toArray()[0]._id;

// Insert all posts in exact order matching Oracle version
db.posts.insertMany([
    {
        post_id: 1,
        content: "Just launched my new AI project! Check out the demo at github.com/tech_guru_alex #AI #Programming",
        created_at: new Date("2024-03-15T09:00:00Z"),
        user: { $ref: "users", $id: user_1006_id }
    },
    {
        post_id: 2,
        content: "Deep dive into Python 3.12 features - Thread coming up! 🧵 #Python #CodingLife",
        created_at: new Date("2024-03-15T11:30:00Z"),
        user: { $ref: "users", $id: user_1006_id }
    },
    {
        post_id: 3,
        content: "My VS Code setup for maximum productivity. Sharing my favorite extensions! 💻",
        created_at: new Date("2024-03-15T14:15:00Z"),
        user: { $ref: "users", $id: user_1006_id }
    },
    {
        post_id: 4,
        content: "Just tried this amazing new ramen place! The broth is to die for 🍜 #FoodBlog",
        created_at: new Date("2024-03-15T12:00:00Z"),
        user: { $ref: "users", $id: user_1008_id }
    },
    {
        post_id: 5,
        content: "Recipe alert! My secret pasta sauce recipe finally revealed! 🍝 #Cooking",
        created_at: new Date("2024-03-15T15:30:00Z"),
        user: { $ref: "users", $id: user_1008_id }
    },
    {
        post_id: 6,
        content: "Food photography tips: How to make your dishes look Instagram-worthy 📸",
        created_at: new Date("2024-03-15T17:45:00Z"),
        user: { $ref: "users", $id: user_1008_id }
    },
    {
        post_id: 7,
        content: "Morning workout completed! 💪 Remember: consistency is key! #FitnessMotivation",
        created_at: new Date("2024-03-15T07:00:00Z"),
        user: { $ref: "users", $id: user_1007_id }
    },
    {
        post_id: 8,
        content: "Quick healthy lunch ideas for busy professionals 🥗",
        created_at: new Date("2024-03-15T12:30:00Z"),
        user: { $ref: "users", $id: user_1007_id }
    },
    {
        post_id: 9,
        content: "Monthly update: Our beach cleanup collected 500kg of plastic! 🌊 #SaveTheOceans",
        created_at: new Date("2024-03-15T16:00:00Z"),
        user: { $ref: "users", $id: user_1013_id }
    },
    {
        post_id: 10,
        content: "New research paper published on quantum computing applications in cryptography",
        created_at: new Date("2024-03-15T14:00:00Z"),
        user: { $ref: "users", $id: user_1016_id }
    },
    {
        post_id: 11,
        content: "Live now! Streaming the new RPG release! Come join! 🎮 #Gaming #LiveStream",
        created_at: new Date("2024-03-15T20:00:00Z"),
        user: { $ref: "users", $id: user_1011_id }
    },
    {
        post_id: 12,
        content: "Game Review: 10 things you need to know about the latest release! 🎮",
        created_at: new Date("2024-03-15T15:30:00Z"),
        user: { $ref: "users", $id: user_1011_id }
    },
    {
        post_id: 13,
        content: "My gaming setup tour! New RGB lighting installed! ✨ #GamingSetup",
        created_at: new Date("2024-03-15T12:45:00Z"),
        user: { $ref: "users", $id: user_1011_id }
    },
    {
        post_id: 14,
        content: "Spring Fashion Haul! 👗 Swipe to see my favorite picks! #FashionBlogger",
        created_at: new Date("2024-03-15T11:00:00Z"),
        user: { $ref: "users", $id: user_1014_id }
    },
    {
        post_id: 15,
        content: "How to style one dress in 5 different ways! 💃 #StyleTips",
        created_at: new Date("2024-03-15T14:30:00Z"),
        user: { $ref: "users", $id: user_1014_id }
    },
    {
        post_id: 16,
        content: "GRWM: Fashion Week Edition! 👠 #FashionWeek #OOTD",
        created_at: new Date("2024-03-15T17:15:00Z"),
        user: { $ref: "users", $id: user_1014_id }
    },
    {
        post_id: 17,
        content: "Learning React Native for mobile development. Any tips? 📱 #coding #mobiledev",
        created_at: new Date("2024-03-14T15:30:00Z"),
        user: { $ref: "users", $id: user_1006_id }
    },
    {
        post_id: 18,
        content: "Exploring machine learning algorithms for my latest project 🤖 #AI #ML",
        created_at: new Date("2024-03-13T10:45:00Z"),
        user: { $ref: "users", $id: user_1016_id }
    },
    {
        post_id: 19,
        content: "5k morning run completed! New personal best! 🏃‍♀️ #Running #Fitness",
        created_at: new Date("2024-03-14T07:15:00Z"),
        user: { $ref: "users", $id: user_1007_id }
    },
    {
        post_id: 20,
        content: "Post-workout protein smoothie recipe! Banana + Peanut butter = 😋 #HealthyLiving",
        created_at: new Date("2024-03-13T16:20:00Z"),
        user: { $ref: "users", $id: user_1020_id }
    },
    {
        post_id: 21,
        content: "Sunset in Bali 🌅 Sometimes you need to get lost to find yourself #Travel",
        created_at: new Date("2024-03-12T18:30:00Z"),
        user: { $ref: "users", $id: user_1010_id }
    },
    {
        post_id: 22,
        content: "New digital art piece finished! Swipe to see the process 🎨 #DigitalArt",
        created_at: new Date("2024-03-11T14:20:00Z"),
        user: { $ref: "users", $id: user_1009_id }
    },
    {
        post_id: 23,
        content: "Homemade sushi night! 🍣 Tutorial coming soon! #Cooking #FoodLover",
        created_at: new Date("2024-03-10T19:15:00Z"),
        user: { $ref: "users", $id: user_1008_id }
    },
    {
        post_id: 24,
        content: "Just hit Diamond rank! The grind was worth it 🎮 #Gaming #ESports",
        created_at: new Date("2024-03-09T22:30:00Z"),
        user: { $ref: "users", $id: user_1011_id }
    },
    {
        post_id: 25,
        content: "Simple ways to reduce your carbon footprint 🌍 Thread below! #Environment",
        created_at: new Date("2024-03-08T11:45:00Z"),
        user: { $ref: "users", $id: user_1013_id }
    },
    {
        post_id: 26,
        content: "New cover song dropping tomorrow! Stay tuned 🎵 #Music #Singer",
        created_at: new Date("2024-03-07T20:00:00Z"),
        user: { $ref: "users", $id: user_1012_id }
    },
    {
        post_id: 27,
        content: "Summer fashion trends 2024 prediction 👗 #Fashion #Style",
        created_at: new Date("2024-03-06T13:15:00Z"),
        user: { $ref: "users", $id: user_1014_id }
    },
    {
        post_id: 28,
        content: "Meet our newest rescue puppy! 🐕 Help us name him! #AdoptDontShop",
        created_at: new Date("2024-03-05T16:40:00Z"),
        user: { $ref: "users", $id: user_1019_id }
    },
    {
        post_id: 29,
        content: "Transformed this $10 thrift store find into a stunning piece! Before and After pics 🎨 #DIY #Upcycling",
        created_at: new Date("2024-03-04T15:20:00Z"),
        user: { $ref: "users", $id: user_1017_id }
    },
    {
        post_id: 30,
        content: "Just finished the first draft of my new novel! 📚 Six months of work finally paying off! #AmWriting",
        created_at: new Date("2024-03-14T23:45:00Z"),
        user: { $ref: "users", $id: user_1013_id }
    },
    {
        post_id: 31,
        content: "Book Review: \"The Midnight Library\" - A masterpiece that makes you question every life choice 📖 #BookReview",
        created_at: new Date("2024-03-13T16:30:00Z"),
        user: { $ref: "users", $id: user_1013_id }
    },
    {
        post_id: 32,
        content: "New choreography sneak peek! 💃 Contemporary piece coming to the studio next week #DanceLife",
        created_at: new Date("2024-03-15T19:20:00Z"),
        user: { $ref: "users", $id: user_1015_id }
    },
    {
        post_id: 33,
        content: "Behind the scenes at today's dance rehearsal! Preparing for the summer showcase 🎭 #DancerLife",
        created_at: new Date("2024-03-14T14:15:00Z"),
        user: { $ref: "users", $id: user_1015_id }
    },
    {
        post_id: 34,
        content: "Big news! Our startup just secured Series A funding! 🚀 Grateful for the amazing team! #StartupLife",
        created_at: new Date("2024-03-15T10:30:00Z"),
        user: { $ref: "users", $id: user_1014_id }
    },
    {
        post_id: 35,
        content: "The future of AI in healthcare - My thoughts on recent developments and what's coming next 🤖 #HealthTech",
        created_at: new Date("2024-03-13T11:45:00Z"),
        user: { $ref: "users", $id: user_1014_id }
    },
    {
        post_id: 36,
        content: "Dawn at Mount Fuji. Sometimes waking up at 4AM is worth it 📸 #Photography #Nature",
        created_at: new Date("2024-03-15T05:30:00Z"),
        user: { $ref: "users", $id: user_1012_id }
    },
    {
        post_id: 37,
        content: "Photography Workshop Announcement! Learn night photography techniques this weekend 🌙 #PhotoWorkshop",
        created_at: new Date("2024-03-14T12:00:00Z"),
        user: { $ref: "users", $id: user_1012_id }
    },
    {
        post_id: 38,
        content: "Championship game highlights! Proud coach moment - our team brought home the trophy! 🏆 #Sports",
        created_at: new Date("2024-03-15T21:00:00Z"),
        user: { $ref: "users", $id: user_1020_id }
    },
    {
        post_id: 39,
        content: "Quick agility drill tutorial 🏃‍♂️ Save this for your next training session! #SportsTraining",
        created_at: new Date("2024-03-14T16:45:00Z"),
        user: { $ref: "users", $id: user_1020_id }
    },
    {
        post_id: 40,
        content: "Transformed this $10 thrift store find into a stunning piece! Before and After pics 🎨 #DIY #Upcycling",
        created_at: new Date("2024-03-15T13:20:00Z"),
        user: { $ref: "users", $id: user_1017_id }
    },
    {
        post_id: 41,
        content: "Easy weekend project: Making your own macramé wall hanging! Tutorial in comments 🧶 #DIYHome",
        created_at: new Date("2024-03-13T14:30:00Z"),
        user: { $ref: "users", $id: user_1017_id }
    },
    {
        post_id: 42,
        content: "Tonight's show was EPIC! Thanks NYC for the amazing energy! 🎤 Next stop: Chicago! #StandUpComedy",
        created_at: new Date("2024-03-15T23:45:00Z"),
        user: { $ref: "users", $id: user_1018_id }
    },
    {
        post_id: 43,
        content: "When your mom says \"we have food at home\" 😂 #ComedySketch #Relatable",
        created_at: new Date("2024-03-14T17:30:00Z"),
        user: { $ref: "users", $id: user_1018_id }
    },
    {
        post_id: 44,
        content: "Successful adoption day at the shelter! 15 pets found their forever homes today! ❤️ #AdoptDontShop",
        created_at: new Date("2024-03-15T18:15:00Z"),
        user: { $ref: "users", $id: user_1019_id }
    },
    {
        post_id: 45,
        content: "Essential tips for first-time cat owners! 🐱 Save this post for later! #PetCare #CatLover",
        created_at: new Date("2024-03-14T13:45:00Z"),
        user: { $ref: "users", $id: user_1019_id }
    }
]);

// Create likes collection with schema validation
db.createCollection("likes", {
    validator: {
        $jsonSchema: {
            bsonType: "object",
            required: ["like_id", "post", "user", "created_at"],
            properties: {
                like_id: { bsonType: "number" },
                post: { bsonType: "object" },
                user: { bsonType: "object" },
                created_at: { bsonType: "date" }
            }
        }
    }
});

// Create indexes for likes - ensure uniqueness on like_id and combination of post/user
db.likes.createIndex({ "like_id": 1 }, { unique: true });
db.likes.createIndex({ "post.$id": 1, "user.$id": 1 }, { unique: true });

// Clear any existing likes data
db.likes.drop();

// Insert likes in exact same order as Oracle database
db.likes.insertMany([
    {
        like_id: 1,
        post: { $ref: "posts", $id: db.posts.find({ post_id: 1 }).toArray()[0]._id },
        user: { $ref: "users", $id: user_1006_id },
        created_at: new Date("2024-03-15T09:15:00Z")
    },
    {
        like_id: 2,
        post: { $ref: "posts", $id: db.posts.find({ post_id: 1 }).toArray()[0]._id },
        user: { $ref: "users", $id: user_1016_id },
        created_at: new Date("2024-03-15T09:30:00Z")
    },
    {
        like_id: 3,
        post: { $ref: "posts", $id: db.posts.find({ post_id: 4 }).toArray()[0]._id },
        user: { $ref: "users", $id: user_1008_id },
        created_at: new Date("2024-03-15T12:05:00Z")
    },
    {
        like_id: 4,
        post: { $ref: "posts", $id: db.posts.find({ post_id: 4 }).toArray()[0]._id },
        user: { $ref: "users", $id: user_1015_id },
        created_at: new Date("2024-03-15T12:15:00Z")
    },
    {
        like_id: 5,
        post: { $ref: "posts", $id: db.posts.find({ post_id: 11 }).toArray()[0]._id },
        user: { $ref: "users", $id: user_1006_id },
        created_at: new Date("2024-03-15T20:05:00Z")
    },
    {
        like_id: 6,
        post: { $ref: "posts", $id: db.posts.find({ post_id: 11 }).toArray()[0]._id },
        user: { $ref: "users", $id: user_1018_id },
        created_at: new Date("2024-03-15T20:10:00Z")
    },
    {
        like_id: 7,
        post: { $ref: "posts", $id: db.posts.find({ post_id: 11 }).toArray()[0]._id },
        user: { $ref: "users", $id: user_1019_id },
        created_at: new Date("2024-03-15T20:15:00Z")
    },
    {
        like_id: 8,
        post: { $ref: "posts", $id: db.posts.find({ post_id: 14 }).toArray()[0]._id },
        user: { $ref: "users", $id: user_1015_id },
        created_at: new Date("2024-03-15T11:30:00Z")
    },
    {
        like_id: 9,
        post: { $ref: "posts", $id: db.posts.find({ post_id: 14 }).toArray()[0]._id },
        user: { $ref: "users", $id: user_1019_id },
        created_at: new Date("2024-03-15T11:45:00Z")
    },
    {
        like_id: 10,
        post: { $ref: "posts", $id: db.posts.find({ post_id: 5 }).toArray()[0]._id },
        user: { $ref: "users", $id: user_1006_id },
        created_at: new Date("2024-03-15T15:45:00Z")
    },
    {
        like_id: 11,
        post: { $ref: "posts", $id: db.posts.find({ post_id: 7 }).toArray()[0]._id },
        user: { $ref: "users", $id: user_1020_id },
        created_at: new Date("2024-03-15T07:15:00Z")
    },
    {
        like_id: 12,
        post: { $ref: "posts", $id: db.posts.find({ post_id: 7 }).toArray()[0]._id },
        user: { $ref: "users", $id: user_1015_id },
        created_at: new Date("2024-03-15T07:30:00Z")
    },
    {
        like_id: 13,
        post: { $ref: "posts", $id: db.posts.find({ post_id: 9 }).toArray()[0]._id },
        user: { $ref: "users", $id: user_1017_id },
        created_at: new Date("2024-03-15T16:30:00Z")
    },
    {
        like_id: 14,
        post: { $ref: "posts", $id: db.posts.find({ post_id: 28 }).toArray()[0]._id },
        user: { $ref: "users", $id: user_1011_id },
        created_at: new Date("2024-03-15T00:15:00Z")
    },
    {
        like_id: 15,
        post: { $ref: "posts", $id: db.posts.find({ post_id: 35 }).toArray()[0]._id },
        user: { $ref: "users", $id: user_1014_id },
        created_at: new Date("2024-03-15T06:00:00Z")
    },
    {
        like_id: 16,
        post: { $ref: "posts", $id: db.posts.find({ post_id: 35 }).toArray()[0]._id },
        user: { $ref: "users", $id: user_1010_id },
        created_at: new Date("2024-03-15T06:15:00Z")
    },
    {
        like_id: 17,
        post: { $ref: "posts", $id: db.posts.find({ post_id: 37 }).toArray()[0]._id },
        user: { $ref: "users", $id: user_1019_id },
        created_at: new Date("2024-03-15T13:45:00Z")
    },
    {
        like_id: 18,
        post: { $ref: "posts", $id: db.posts.find({ post_id: 40 }).toArray()[0]._id },
        user: { $ref: "users", $id: user_1011_id },
        created_at: new Date("2024-03-16T00:00:00Z")
    },
    {
        like_id: 19,
        post: { $ref: "posts", $id: db.posts.find({ post_id: 41 }).toArray()[0]._id },
        user: { $ref: "users", $id: user_1015_id },
        created_at: new Date("2024-03-15T18:30:00Z")
    },
    {
        like_id: 20,
        post: { $ref: "posts", $id: db.posts.find({ post_id: 41 }).toArray()[0]._id },
        user: { $ref: "users", $id: user_1017_id },
        created_at: new Date("2024-03-15T18:45:00Z")
    },
    {
        like_id: 21,
        post: { $ref: "posts", $id: db.posts.find({ post_id: 1 }).toArray()[0]._id },
        user: { $ref: "users", $id: user_1007_id },
        created_at: new Date("2024-03-15T09:45:00Z")
    },
    {
        like_id: 22,
        post: { $ref: "posts", $id: db.posts.find({ post_id: 2 }).toArray()[0]._id },
        user: { $ref: "users", $id: user_1014_id },
        created_at: new Date("2024-03-15T11:35:00Z")
    },
    {
        like_id: 23,
        post: { $ref: "posts", $id: db.posts.find({ post_id: 4 }).toArray()[0]._id },
        user: { $ref: "users", $id: user_1010_id },
        created_at: new Date("2024-03-15T12:30:00Z")
    },
    {
        like_id: 24,
        post: { $ref: "posts", $id: db.posts.find({ post_id: 5 }).toArray()[0]._id },
        user: { $ref: "users", $id: user_1012_id },
        created_at: new Date("2024-03-15T15:50:00Z")
    },
    {
        like_id: 25,
        post: { $ref: "posts", $id: db.posts.find({ post_id: 11 }).toArray()[0]._id },
        user: { $ref: "users", $id: user_1013_id },
        created_at: new Date("2024-03-15T20:20:00Z")
    },
    {
        like_id: 26,
        post: { $ref: "posts", $id: db.posts.find({ post_id: 12 }).toArray()[0]._id },
        user: { $ref: "users", $id: user_1016_id },
        created_at: new Date("2024-03-15T13:00:00Z")
    },
    {
        like_id: 27,
        post: { $ref: "posts", $id: db.posts.find({ post_id: 14 }).toArray()[0]._id },
        user: { $ref: "users", $id: user_1007_id },
        created_at: new Date("2024-03-15T11:50:00Z")
    },
    {
        like_id: 28,
        post: { $ref: "posts", $id: db.posts.find({ post_id: 7 }).toArray()[0]._id },
        user: { $ref: "users", $id: user_1011_id },
        created_at: new Date("2024-03-15T08:00:00Z")
    },
    {
        like_id: 29,
        post: { $ref: "posts", $id: db.posts.find({ post_id: 9 }).toArray()[0]._id },
        user: { $ref: "users", $id: user_1008_id },
        created_at: new Date("2024-03-15T16:45:00Z")
    },
    {
        like_id: 30,
        post: { $ref: "posts", $id: db.posts.find({ post_id: 35 }).toArray()[0]._id },
        user: { $ref: "users", $id: user_1013_id },
        created_at: new Date("2024-03-15T06:30:00Z")
    },
    {
        like_id: 31,
        post: { $ref: "posts", $id: db.posts.find({ post_id: 37 }).toArray()[0]._id },
        user: { $ref: "users", $id: user_1008_id },
        created_at: new Date("2024-03-15T13:15:00Z")
    },
    {
        like_id: 32,
        post: { $ref: "posts", $id: db.posts.find({ post_id: 40 }).toArray()[0]._id },
        user: { $ref: "users", $id: user_1007_id },
        created_at: new Date("2024-03-16T00:15:00Z")
    },
    {
        like_id: 33,
        post: { $ref: "posts", $id: db.posts.find({ post_id: 41 }).toArray()[0]._id },
        user: { $ref: "users", $id: user_1014_id },
        created_at: new Date("2024-03-15T18:55:00Z")
    },
    {
        like_id: 34,
        post: { $ref: "posts", $id: db.posts.find({ post_id: 1 }).toArray()[0]._id },
        user: { $ref: "users", $id: user_1009_id },
        created_at: new Date("2024-03-15T23:55:00Z")
    },
    {
        like_id: 35,
        post: { $ref: "posts", $id: db.posts.find({ post_id: 40 }).toArray()[0]._id },
        user: { $ref: "users", $id: user_1011_id },
        created_at: new Date("2024-03-15T11:25:00Z")
    },
    {
        like_id: 36,
        post: { $ref: "posts", $id: db.posts.find({ post_id: 14 }).toArray()[0]._id },
        user: { $ref: "users", $id: user_1020_id },
        created_at: new Date("2024-03-15T18:25:00Z")
    }
]);

// Create comments collection with schema validation
db.createCollection("comments", {
    validator: {
        $jsonSchema: {
            bsonType: "object",
            required: ["comment_id", "content", "created_at", "user", "post"],
            properties: {
                comment_id: { bsonType: "number" },
                content: { bsonType: "string" },
                created_at: { bsonType: "date" },
                user: { bsonType: "object" },
                post: { bsonType: "object" }
            }
        }
    }
});

// Create indexes for comments
db.comments.createIndex({ "comment_id": 1 }, { unique: true });
db.comments.createIndex({ "post.$id": 1, "user.$id": 1 });

// Clear any existing comments data
db.comments.drop();

// Insert comments in exact same order as Oracle database
db.comments.insertMany([
    {
        comment_id: 1,
        content: "This AI project looks amazing! Would love to contribute.",
        created_at: new Date("2024-03-15T09:30:00Z"),
        user: { $ref: "users", $id: user_1016_id },
        post: { $ref: "posts", $id: db.posts.find({ post_id: 1 }).toArray()[0]._id }
    },
    {
        comment_id: 2,
        content: "Have you considered implementing neural networks for this?",
        created_at: new Date("2024-03-15T09:45:00Z"),
        user: { $ref: "users", $id: user_1014_id },
        post: { $ref: "posts", $id: db.posts.find({ post_id: 1 }).toArray()[0]._id }
    },
    {
        comment_id: 3,
        content: "That ramen looks incredible! Which restaurant is this?",
        created_at: new Date("2024-03-15T12:30:00Z"),
        user: { $ref: "users", $id: user_1015_id },
        post: { $ref: "posts", $id: db.posts.find({ post_id: 4 }).toArray()[0]._id }
    },
    {
        comment_id: 4,
        content: "Your food photography skills are getting better every day!",
        created_at: new Date("2024-03-15T12:45:00Z"),
        user: { $ref: "users", $id: user_1012_id },
        post: { $ref: "posts", $id: db.posts.find({ post_id: 4 }).toArray()[0]._id }
    },
    {
        comment_id: 5,
        content: "Thanks for sharing these VS Code tips! The Python extension is a game-changer.",
        created_at: new Date("2024-03-15T14:30:00Z"),
        user: { $ref: "users", $id: user_1006_id },
        post: { $ref: "posts", $id: db.posts.find({ post_id: 3 }).toArray()[0]._id }
    },
    {
        comment_id: 6,
        content: "Which theme are you using? It looks clean!",
        created_at: new Date("2024-03-15T14:45:00Z"),
        user: { $ref: "users", $id: user_1016_id },
        post: { $ref: "posts", $id: db.posts.find({ post_id: 3 }).toArray()[0]._id }
    },
    {
        comment_id: 7,
        content: "Great workout routine! Could you share more about your warm-up?",
        created_at: new Date("2024-03-15T07:30:00Z"),
        user: { $ref: "users", $id: user_1020_id },
        post: { $ref: "posts", $id: db.posts.find({ post_id: 7 }).toArray()[0]._id }
    },
    {
        comment_id: 8,
        content: "Love these sustainable fashion choices! Where did you get that eco-friendly bag?",
        created_at: new Date("2024-03-15T11:15:00Z"),
        user: { $ref: "users", $id: user_1013_id },
        post: { $ref: "posts", $id: db.posts.find({ post_id: 14 }).toArray()[0]._id }
    },
    {
        comment_id: 9,
        content: "That Mount Fuji shot is breathtaking! What camera settings did you use?",
        created_at: new Date("2024-03-15T06:15:00Z"),
        user: { $ref: "users", $id: user_1012_id },
        post: { $ref: "posts", $id: db.posts.find({ post_id: 35 }).toArray()[0]._id }
    },
    {
        comment_id: 10,
        content: "The lighting in this photo is perfect! Golden hour magic ✨",
        created_at: new Date("2024-03-15T06:30:00Z"),
        user: { $ref: "users", $id: user_1014_id },
        post: { $ref: "posts", $id: db.posts.find({ post_id: 35 }).toArray()[0]._id }
    },
    {
        comment_id: 11,
        content: "Such a heartwarming adoption day! Those pets look so happy 🐾",
        created_at: new Date("2024-03-15T18:45:00Z"),
        user: { $ref: "users", $id: user_1019_id },
        post: { $ref: "posts", $id: db.posts.find({ post_id: 41 }).toArray()[0]._id }
    },
    {
        comment_id: 12,
        content: "Your DIY skills are incredible! Tutorial please! 🙏",
        created_at: new Date("2024-03-15T13:45:00Z"),
        user: { $ref: "users", $id: user_1017_id },
        post: { $ref: "posts", $id: db.posts.find({ post_id: 37 }).toArray()[0]._id }
    },
    {
        comment_id: 13,
        content: "This comedy show was hilarious! When is your next performance?",
        created_at: new Date("2024-03-16T00:00:00Z"),
        user: { $ref: "users", $id: user_1011_id },
        post: { $ref: "posts", $id: db.posts.find({ post_id: 40 }).toArray()[0]._id }
    },
    {
        comment_id: 14,
        content: "Your dance choreography is so innovative! Love the fusion elements.",
        created_at: new Date("2024-03-15T19:30:00Z"),
        user: { $ref: "users", $id: user_1015_id },
        post: { $ref: "posts", $id: db.posts.find({ post_id: 29 }).toArray()[0]._id }
    },
    {
        comment_id: 15,
        content: "This startup journey is inspiring! Any advice for new entrepreneurs?",
        created_at: new Date("2024-03-15T11:00:00Z"),
        user: { $ref: "users", $id: user_1014_id },
        post: { $ref: "posts", $id: db.posts.find({ post_id: 33 }).toArray()[0]._id }
    },
    {
        comment_id: 16,
        content: "Just tried your recipe and it turned out amazing! The secret ingredient really makes a difference 👨‍🍳",
        created_at: new Date("2024-03-15T17:00:00Z"),
        user: { $ref: "users", $id: user_1010_id },
        post: { $ref: "posts", $id: db.posts.find({ post_id: 5 }).toArray()[0]._id }
    },
    {
        comment_id: 17,
        content: "Could you do a beginner-friendly version of this workout? Looking to start my fitness journey!",
        created_at: new Date("2024-03-15T08:15:00Z"),
        user: { $ref: "users", $id: user_1008_id },
        post: { $ref: "posts", $id: db.posts.find({ post_id: 7 }).toArray()[0]._id }
    },
    {
        comment_id: 18,
        content: "The way you explained these Python features makes it so much clearer. Especially the new pattern matching!",
        created_at: new Date("2024-03-15T11:45:00Z"),
        user: { $ref: "users", $id: user_1016_id },
        post: { $ref: "posts", $id: db.posts.find({ post_id: 2 }).toArray()[0]._id }
    },
    {
        comment_id: 19,
        content: "Been following your gaming streams for months now. Your commentary always makes my day! 🎮",
        created_at: new Date("2024-03-15T20:30:00Z"),
        user: { $ref: "users", $id: user_1019_id },
        post: { $ref: "posts", $id: db.posts.find({ post_id: 11 }).toArray()[0]._id }
    },
    {
        comment_id: 20,
        content: "These beach cleanup initiatives are so important! Count me in for the next one! 🌊",
        created_at: new Date("2024-03-15T16:30:00Z"),
        user: { $ref: "users", $id: user_1017_id },
        post: { $ref: "posts", $id: db.posts.find({ post_id: 9 }).toArray()[0]._id }
    },
    {
        comment_id: 21,
        content: "The quantum computing implications here are fascinating. Have you considered the potential impact on blockchain?",
        created_at: new Date("2024-03-15T14:30:00Z"),
        user: { $ref: "users", $id: user_1006_id },
        post: { $ref: "posts", $id: db.posts.find({ post_id: 10 }).toArray()[0]._id }
    },
    {
        comment_id: 22,
        content: "Your style evolution this year has been incredible! Love how you mix vintage with modern pieces 👗",
        created_at: new Date("2024-03-15T15:15:00Z"),
        user: { $ref: "users", $id: user_1015_id },
        post: { $ref: "posts", $id: db.posts.find({ post_id: 14 }).toArray()[0]._id }
    },
    {
        comment_id: 23,
        content: "This series of photos tells such a beautiful story. The progression from dawn to dusk is masterful 📸",
        created_at: new Date("2024-03-15T07:00:00Z"),
        user: { $ref: "users", $id: user_1014_id },
        post: { $ref: "posts", $id: db.posts.find({ post_id: 35 }).toArray()[0]._id }
    },
    {
        comment_id: 24,
        content: "As a fellow entrepreneur, I resonate with these challenges. Building a startup is definitely a roller coaster!",
        created_at: new Date("2024-03-15T11:30:00Z"),
        user: { $ref: "users", $id: user_1006_id },
        post: { $ref: "posts", $id: db.posts.find({ post_id: 33 }).toArray()[0]._id }
    },
    {
        comment_id: 25,
        content: "The way you blend different dance styles is so unique. Would love to collaborate on a fusion piece! 💃",
        created_at: new Date("2024-03-15T20:00:00Z"),
        user: { $ref: "users", $id: user_1007_id },
        post: { $ref: "posts", $id: db.posts.find({ post_id: 29 }).toArray()[0]._id }
    },
    {
        comment_id: 26,
        content: "This Python tutorial series is exactly what I needed! The examples are so practical 🐍",
        created_at: new Date("2024-03-15T12:00:00Z"),
        user: { $ref: "users", $id: user_1007_id },
        post: { $ref: "posts", $id: db.posts.find({ post_id: 2 }).toArray()[0]._id }
    },
    {
        comment_id: 27,
        content: "Could you make a follow-up video on advanced pattern matching cases?",
        created_at: new Date("2024-03-15T12:15:00Z"),
        user: { $ref: "users", $id: user_1020_id },
        post: { $ref: "posts", $id: db.posts.find({ post_id: 2 }).toArray()[0]._id }
    },
    {
        comment_id: 28,
        content: "The error handling section was particularly helpful. Fixed my project issues! 💻",
        created_at: new Date("2024-03-15T12:30:00Z"),
        user: { $ref: "users", $id: user_1013_id },
        post: { $ref: "posts", $id: db.posts.find({ post_id: 2 }).toArray()[0]._id }
    },
    {
        comment_id: 29,
        content: "This ramen spot is now my weekend favorite! The broth is incredible 🍜",
        created_at: new Date("2024-03-15T13:00:00Z"),
        user: { $ref: "users", $id: user_1016_id },
        post: { $ref: "posts", $id: db.posts.find({ post_id: 4 }).toArray()[0]._id }
    },
    {
        comment_id: 30,
        content: "Went there today because of your post - the line was worth it!",
        created_at: new Date("2024-03-15T19:45:00Z"),
        user: { $ref: "users", $id: user_1019_id },
        post: { $ref: "posts", $id: db.posts.find({ post_id: 4 }).toArray()[0]._id }
    },
    {
        comment_id: 31,
        content: "Their vegetarian option is amazing too! Great recommendation 🌱",
        created_at: new Date("2024-03-15T20:15:00Z"),
        user: { $ref: "users", $id: user_1013_id },
        post: { $ref: "posts", $id: db.posts.find({ post_id: 4 }).toArray()[0]._id }
    },
    {
        comment_id: 32,
        content: "This HIIT routine is intense but effective! Lost 5kg following your workouts 💪",
        created_at: new Date("2024-03-15T08:30:00Z"),
        user: { $ref: "users", $id: user_1014_id },
        post: { $ref: "posts", $id: db.posts.find({ post_id: 7 }).toArray()[0]._id }
    },
    {
        comment_id: 33,
        content: "The modified versions for beginners are so thoughtful! Thank you! 🏃‍♀️",
        created_at: new Date("2024-03-15T09:15:00Z"),
        user: { $ref: "users", $id: user_1019_id },
        post: { $ref: "posts", $id: db.posts.find({ post_id: 7 }).toArray()[0]._id }
    },
    {
        comment_id: 34,
        content: "Been doing this routine for a month - my endurance has improved significantly!",
        created_at: new Date("2024-03-15T10:00:00Z"),
        user: { $ref: "users", $id: user_1015_id },
        post: { $ref: "posts", $id: db.posts.find({ post_id: 7 }).toArray()[0]._id }
    },
    {
        comment_id: 35,
        content: "The integration with TensorFlow is brilliant! Mind sharing your model architecture?",
        created_at: new Date("2024-03-15T10:30:00Z"),
        user: { $ref: "users", $id: user_1016_id },
        post: { $ref: "posts", $id: db.posts.find({ post_id: 1 }).toArray()[0]._id }
    },
    {
        comment_id: 36,
        content: "Impressive accuracy rates! How did you handle the data preprocessing? 🤖",
        created_at: new Date("2024-03-15T11:00:00Z"),
        user: { $ref: "users", $id: user_1020_id },
        post: { $ref: "posts", $id: db.posts.find({ post_id: 1 }).toArray()[0]._id }
    },
    {
        comment_id: 37,
        content: "This Mount Fuji series belongs in a gallery! The composition is perfect 🗻",
        created_at: new Date("2024-03-15T07:30:00Z"),
        user: { $ref: "users", $id: user_1008_id },
        post: { $ref: "posts", $id: db.posts.find({ post_id: 35 }).toArray()[0]._id }
    },
    {
        comment_id: 38,
        content: "The way you captured the morning mist is ethereal! What time did you start hiking?",
        created_at: new Date("2024-03-15T08:00:00Z"),
        user: { $ref: "users", $id: user_1015_id },
        post: { $ref: "posts", $id: db.posts.find({ post_id: 35 }).toArray()[0]._id }
    },
    {
        comment_id: 39,
        content: "Your funding journey is so inspiring! Would love to hear more about your pitch deck preparation 📊",
        created_at: new Date("2024-03-15T13:30:00Z"),
        user: { $ref: "users", $id: user_1016_id },
        post: { $ref: "posts", $id: db.posts.find({ post_id: 33 }).toArray()[0]._id }
    },
    {
        comment_id: 40,
        content: "The section about bootstrapping really resonated with me. Pure startup wisdom! 💡",
        created_at: new Date("2024-03-15T14:15:00Z"),
        user: { $ref: "users", $id: user_1008_id },
        post: { $ref: "posts", $id: db.posts.find({ post_id: 33 }).toArray()[0]._id }
    }
]);


