-- Drop sequences if they exist
DROP SEQUENCE message_id_seq;

DROP SEQUENCE like_id_seq;

DROP SEQUENCE comment_id_seq;

DROP SEQUENCE post_id_seq;

DROP SEQUENCE user_id_seq;

-- Drop tables if they exist
DROP TABLE Messages CASCADE CONSTRAINTS;

DROP TABLE Likes CASCADE CONSTRAINTS;

DROP TABLE Comments CASCADE CONSTRAINTS;

DROP TABLE Posts CASCADE CONSTRAINTS;

DROP TABLE Users CASCADE CONSTRAINTS;

-- Drop types if they exist (order matters due to dependencies)
DROP TYPE MessageType FORCE;

DROP TYPE CommentType FORCE;

DROP TYPE LikeType FORCE;

DROP TYPE PostType FORCE;

DROP TYPE RegularUserType FORCE;

DROP TYPE AdminType FORCE;

DROP TYPE UserType FORCE;

-- User object type with attributes common to all users
CREATE
OR REPLACE TYPE UserType AS OBJECT (
    user_id NUMBER,
    username VARCHAR2 (50),
    email VARCHAR2 (100),
    password_hash VARCHAR2 (255),
    created_at TIMESTAMP,
    profile_picture VARCHAR2 (500),
    user_type VARCHAR2 (255)
) NOT FINAL;

/
-- Admin object type inheriting from UserType
CREATE
OR REPLACE TYPE AdminType UNDER UserType (
    admin_id NUMBER,
    report_viewed NUMBER,
    last_login TIMESTAMP,
    admin_level NUMBER
);

/
-- RegularUser object type inheriting from UserType
CREATE
OR REPLACE TYPE RegularUserType UNDER UserType (
    bio VARCHAR2 (4000),
    user_status VARCHAR2 (255),
    followers NUMBER,
    following NUMBER
);

/
-- Post object type
CREATE
OR REPLACE TYPE PostType AS OBJECT (
    post_id NUMBER,
    content VARCHAR2 (4000),
    created_at TIMESTAMP,
    user_ref REF UserType
);

/
-- Like object type
CREATE
OR REPLACE TYPE LikeType AS OBJECT (
    like_id NUMBER,
    user_ref REF UserType,
    post_ref REF PostType,
    created_at TIMESTAMP
);

/
-- Comment object type
CREATE
OR REPLACE TYPE CommentType AS OBJECT (
    comment_id NUMBER,
    content VARCHAR2 (4000),
    created_at TIMESTAMP,
    user_ref REF UserType,
    post_ref REF PostType
);

/
-- Message object type for private communication
CREATE
OR REPLACE TYPE MessageType AS OBJECT (
    message_id NUMBER,
    content VARCHAR2 (4000),
    sent_at TIMESTAMP,
    sender_ref REF UserType,
    receiver_ref REF UserType
);

/
COMMIT;

-- Finished creating types for the database
-- Creating tables for the database
-- Users table (Object table of UserType)
CREATE TABLE
    Users OF UserType (
        user_id PRIMARY KEY,
        username UNIQUE NOT NULL,
        email UNIQUE NOT NULL,
        password_hash NOT NULL,
        user_type NOT NULL
    );

-- Posts table (Object table of PostType)
CREATE TABLE
    Posts OF PostType (
        post_id PRIMARY KEY,
        content NOT NULL,
        created_at NOT NULL,
        user_ref SCOPE IS Users NOT NULL
    );

-- Comments table (Object table of CommentType)
CREATE TABLE
    Comments OF CommentType (
        comment_id PRIMARY KEY,
        content NOT NULL,
        created_at NOT NULL,
        user_ref SCOPE IS Users NOT NULL,
        post_ref SCOPE IS Posts NOT NULL
    );

-- Likes table (Object table of LikeType)
CREATE TABLE
    Likes OF LikeType (
        like_id PRIMARY KEY,
        created_at NOT NULL,
        user_ref SCOPE IS Users NOT NULL,
        post_ref SCOPE IS Posts NOT NULL
    );

-- Messages table (Object table of MessageType)
CREATE TABLE
    Messages OF MessageType (
        message_id PRIMARY KEY,
        content NOT NULL,
        sent_at NOT NULL,
        sender_ref SCOPE IS Users NOT NULL,
        receiver_ref SCOPE IS Users NOT NULL
    );

-- Create sequences for generating IDs
CREATE SEQUENCE user_id_seq START
WITH
    1 INCREMENT BY 1;

CREATE SEQUENCE post_id_seq START
WITH
    1 INCREMENT BY 1;

CREATE SEQUENCE comment_id_seq START
WITH
    1 INCREMENT BY 1;

CREATE SEQUENCE like_id_seq START
WITH
    1 INCREMENT BY 1;

CREATE SEQUENCE message_id_seq START
WITH
    1 INCREMENT BY 1;

--inserting data
-- Insert admin users
-- Insert Admin Users
--admin 1
INSERT INTO
    Users
VALUES
    (
        AdminType (
            user_id_seq.NEXTVAL,
            'admin_sarah',
            'sarah.admin@platform.com',
            'hashed_admin_pwd_1',
            TIMESTAMP '2023-01-01 09:00:00',
            'admin_profiles/sarah.jpg',
            'admin',
            1001,
            250,
            TIMESTAMP '2024-03-15 14:30:00',
            1
        )
    );

--admin 2
INSERT INTO
    Users
VALUES
    (
        AdminType (
            user_id_seq.NEXTVAL,
            'admin_michael',
            'michael.admin@platform.com',
            'hashed_admin_pwd_2',
            TIMESTAMP '2023-01-02 10:00:00',
            'admin_profiles/michael.jpg',
            'admin',
            1002,
            180,
            TIMESTAMP '2024-03-15 16:45:00',
            2
        )
    );

--admin 3
INSERT INTO
    Users
VALUES
    (
        AdminType (
            user_id_seq.NEXTVAL,
            'admin_jessica',
            'jessica.admin@platform.com',
            'hashed_admin_pwd_3',
            TIMESTAMP '2023-01-03 11:00:00',
            'admin_profiles/jessica.jpg',
            'admin',
            1003,
            320,
            TIMESTAMP '2024-03-15 15:20:00',
            1
        )
    );

--admin 4
INSERT INTO
    Users
VALUES
    (
        AdminType (
            user_id_seq.NEXTVAL,
            'admin_david',
            'david.admin@platform.com',
            'hashed_admin_pwd_4',
            TIMESTAMP '2023-01-04 12:00:00',
            'admin_profiles/david.jpg',
            'admin',
            1004,
            290,
            TIMESTAMP '2024-03-15 17:10:00',
            2
        )
    );

--admin 5
INSERT INTO
    Users
VALUES
    (
        AdminType (
            user_id_seq.NEXTVAL,
            'admin_emma',
            'emma.admin@platform.com',
            'hashed_admin_pwd_5',
            TIMESTAMP '2023-01-05 13:00:00',
            'admin_profiles/emma.jpg',
            'admin',
            1005,
            275,
            TIMESTAMP '2024-03-15 18:00:00',
            1
        )
    );

-- Insert Regular Users with adjusted follower/following counts (max 20)
--user 1
INSERT INTO
    Users
VALUES
    (
        RegularUserType (
            user_id_seq.NEXTVAL,
            'tech_guru_alex',
            'alex@email.com',
            'hashed_pwd_1',
            TIMESTAMP '2023-02-01 10:00:00',
            'profiles/alex.jpg',
            'regular',
            'Software Developer | AI Enthusiast | Coffee Lover',
            'Coding something cool',
            15,
            12
        )
    );

--user 2
INSERT INTO
    Users
VALUES
    (
        RegularUserType (
            user_id_seq.NEXTVAL,
            'fitness_jane',
            'jane@email.com',
            'hashed_pwd_2',
            TIMESTAMP '2023-02-02 11:00:00',
            'profiles/jane.jpg',
            'regular',
            'Personal Trainer | Nutrition Expert',
            'At the gym 💪',
            18,
            15
        )
    );

--user 3
INSERT INTO
    Users
VALUES
    (
        RegularUserType (
            user_id_seq.NEXTVAL,
            'foodie_mark',
            'mark@email.com',
            'hashed_pwd_3',
            TIMESTAMP '2023-02-03 12:00:00',
            'profiles/mark.jpg',
            'regular',
            'Food Blogger | Chef | Restaurant Explorer',
            'Cooking up something special',
            20,
            17
        )
    );

--user 4
INSERT INTO
    Users
VALUES
    (
        RegularUserType (
            user_id_seq.NEXTVAL,
            'artist_lisa',
            'lisa@email.com',
            'hashed_pwd_4',
            TIMESTAMP '2023-02-04 13:00:00',
            'profiles/lisa.jpg',
            'regular',
            'Digital Artist | Illustrator',
            'Creating new artwork',
            16,
            14
        )
    );

--user 5
INSERT INTO
    Users
VALUES
    (
        RegularUserType (
            user_id_seq.NEXTVAL,
            'travel_mike',
            'mike@email.com',
            'hashed_pwd_5',
            TIMESTAMP '2023-02-05 14:00:00',
            'profiles/mike.jpg',
            'regular',
            'World Traveler | Photographer',
            'Exploring new places',
            19,
            16
        )
    );

--user 6
INSERT INTO
    Users
VALUES
    (
        RegularUserType (
            user_id_seq.NEXTVAL,
            'gamer_sam',
            'sam@email.com',
            'hashed_pwd_6',
            TIMESTAMP '2023-02-06 15:00:00',
            'profiles/sam.jpg',
            'regular',
            'Professional Gamer | Streamer',
            'Live streaming now!',
            20,
            18
        )
    );

--user 7
INSERT INTO
    Users
VALUES
    (
        RegularUserType (
            user_id_seq.NEXTVAL,
            'music_rachel',
            'rachel@email.com',
            'hashed_pwd_7',
            TIMESTAMP '2023-02-07 16:00:00',
            'profiles/rachel.jpg',
            'regular',
            'Singer | Songwriter | Producer',
            'Making music 🎵',
            17,
            15
        )
    );

--user 8
INSERT INTO
    Users
VALUES
    (
        RegularUserType (
            user_id_seq.NEXTVAL,
            'eco_peter',
            'peter@email.com',
            'hashed_pwd_8',
            TIMESTAMP '2023-02-08 17:00:00',
            'profiles/peter.jpg',
            'regular',
            'Environmental Activist | Sustainable Living',
            'Saving the planet 🌍',
            14,
            12
        )
    );

--user 9
INSERT INTO
    Users
VALUES
    (
        RegularUserType (
            user_id_seq.NEXTVAL,
            'fashion_nina',
            'nina@email.com',
            'hashed_pwd_9',
            TIMESTAMP '2023-02-09 18:00:00',
            'profiles/nina.jpg',
            'regular',
            'Fashion Blogger | Style Consultant',
            'Fashion week ready',
            20,
            16
        )
    );

--user 10
INSERT INTO
    Users
VALUES
    (
        RegularUserType (
            user_id_seq.NEXTVAL,
            'chef_carlos',
            'carlos@email.com',
            'hashed_pwd_10',
            TIMESTAMP '2023-02-10 19:00:00',
            'profiles/carlos.jpg',
            'regular',
            'Professional Chef | Food Photography',
            'In the kitchen',
            18,
            15
        )
    );

--user 11
INSERT INTO
    Users
VALUES
    (
        RegularUserType (
            user_id_seq.NEXTVAL,
            'yoga_emma',
            'emma.y@email.com',
            'hashed_pwd_11',
            TIMESTAMP '2023-02-11 20:00:00',
            'profiles/emma_y.jpg',
            'regular',
            'Yoga Instructor | Mindfulness Coach',
            'Namaste 🧘‍♀️',
            16,
            13
        )
    );

--user 12
INSERT INTO
    Users
VALUES
    (
        RegularUserType (
            user_id_seq.NEXTVAL,
            'photographer_tom',
            'tom@email.com',
            'hashed_pwd_12',
            TIMESTAMP '2023-02-12 21:00:00',
            'profiles/tom.jpg',
            'regular',
            'Professional Photographer | Nature Lover',
            'Capturing moments',
            19,
            17
        )
    );

--user 13
INSERT INTO
    Users
VALUES
    (
        RegularUserType (
            user_id_seq.NEXTVAL,
            'writer_sophia',
            'sophia@email.com',
            'hashed_pwd_13',
            TIMESTAMP '2023-02-13 22:00:00',
            'profiles/sophia.jpg',
            'regular',
            'Author | Book Reviewer | Coffee Addict',
            'Writing my next novel',
            15,
            14
        )
    );

--user 14
INSERT INTO
    Users
VALUES
    (
        RegularUserType (
            user_id_seq.NEXTVAL,
            'startup_ryan',
            'ryan@email.com',
            'hashed_pwd_14',
            TIMESTAMP '2023-02-14 23:00:00',
            'profiles/ryan.jpg',
            'regular',
            'Entrepreneur | Tech Startup Founder',
            'Building the future',
            20,
            15
        )
    );

--user 15
INSERT INTO
    Users
VALUES
    (
        RegularUserType (
            user_id_seq.NEXTVAL,
            'dancer_maria',
            'maria@email.com',
            'hashed_pwd_15',
            TIMESTAMP '2023-02-15 00:00:00',
            'profiles/maria.jpg',
            'regular',
            'Professional Dancer | Dance Instructor',
            'Dancing through life 💃',
            18,
            16
        )
    );

--user 16
INSERT INTO
    Users
VALUES
    (
        RegularUserType (
            user_id_seq.NEXTVAL,
            'scientist_alan',
            'alan@email.com',
            'hashed_pwd_16',
            TIMESTAMP '2023-02-16 01:00:00',
            'profiles/alan.jpg',
            'regular',
            'Research Scientist | Physics Enthusiast',
            'Exploring the universe',
            13,
            11
        )
    );

--user 17
INSERT INTO
    Users
VALUES
    (
        RegularUserType (
            user_id_seq.NEXTVAL,
            'diy_hannah',
            'hannah@email.com',
            'hashed_pwd_17',
            TIMESTAMP '2023-02-17 02:00:00',
            'profiles/hannah.jpg',
            'regular',
            'DIY Expert | Home Improvement',
            'Creating something new',
            17,
            14
        )
    );

--user 18
INSERT INTO
    Users
VALUES
    (
        RegularUserType (
            user_id_seq.NEXTVAL,
            'comedian_jack',
            'jack@email.com',
            'hashed_pwd_18',
            TIMESTAMP '2023-02-18 03:00:00',
            'profiles/jack.jpg',
            'regular',
            'Stand-up Comedian | Content Creator',
            'Making people laugh 😂',
            20,
            18
        )
    );

--user 19
INSERT INTO
    Users
VALUES
    (
        RegularUserType (
            user_id_seq.NEXTVAL,
            'pet_lover_lucy',
            'lucy@email.com',
            'hashed_pwd_19',
            TIMESTAMP '2023-02-19 04:00:00',
            'profiles/lucy.jpg',
            'regular',
            'Pet Influencer | Animal Rescue Advocate',
            'Playing with puppies 🐕',
            19,
            16
        )
    );

--user 20
INSERT INTO
    Users
VALUES
    (
        RegularUserType (
            user_id_seq.NEXTVAL,
            'sports_coach_ben',
            'ben@email.com',
            'hashed_pwd_20',
            TIMESTAMP '2023-02-20 05:00:00',
            'profiles/ben.jpg',
            'regular',
            'Sports Coach | Fitness Expert',
            'Training champions',
            17,
            15
        )
    );

COMMIT;

-- inserting posts
INSERT INTO
    Posts
VALUES
    (
        PostType (
            post_id_seq.NEXTVAL,
            'Just launched my new AI project! Check out the demo at github.com/tech_guru_alex #AI #Programming',
            TIMESTAMP '2024-03-15 09:00:00',
            (
                SELECT
                    REF (u)
                FROM
                    Users u
                WHERE
                    u.user_id = 6
            )
        )
    );

INSERT INTO
    Posts
VALUES
    (
        PostType (
            post_id_seq.NEXTVAL,
            'Deep dive into Python 3.12 features - Thread coming up! 🧵 #Python #CodingLife',
            TIMESTAMP '2024-03-15 11:30:00',
            (
                SELECT
                    REF (u)
                FROM
                    Users u
                WHERE
                    u.user_id = 6
            )
        )
    );

INSERT INTO
    Posts
VALUES
    (
        PostType (
            post_id_seq.NEXTVAL,
            'My VS Code setup for maximum productivity. Sharing my favorite extensions! 💻',
            TIMESTAMP '2024-03-15 14:15:00',
            (
                SELECT
                    REF (u)
                FROM
                    Users u
                WHERE
                    u.user_id = 6
            )
        )
    );

INSERT INTO
    Posts
VALUES
    (
        PostType (
            post_id_seq.NEXTVAL,
            'Just tried this amazing new ramen place! The broth is to die for 🍜 #FoodBlog',
            TIMESTAMP '2024-03-15 12:00:00',
            (
                SELECT
                    REF (u)
                FROM
                    Users u
                WHERE
                    u.user_id = 8
            )
        )
    );

INSERT INTO
    Posts
VALUES
    (
        PostType (
            post_id_seq.NEXTVAL,
            'Recipe alert! My secret pasta sauce recipe finally revealed! 🍝 #Cooking',
            TIMESTAMP '2024-03-15 15:30:00',
            (
                SELECT
                    REF (u)
                FROM
                    Users u
                WHERE
                    u.user_id = 8
            )
        )
    );

INSERT INTO
    Posts
VALUES
    (
        PostType (
            post_id_seq.NEXTVAL,
            'Food photography tips: How to make your dishes look Instagram-worthy 📸',
            TIMESTAMP '2024-03-15 17:45:00',
            (
                SELECT
                    REF (u)
                FROM
                    Users u
                WHERE
                    u.user_id = 8
            )
        )
    );

-- Moderately active users (fitness_jane - ID 7)
INSERT INTO
    Posts
VALUES
    (
        PostType (
            post_id_seq.NEXTVAL,
            'Morning workout completed! 💪 Remember: consistency is key! #FitnessMotivation',
            TIMESTAMP '2024-03-15 07:00:00',
            (
                SELECT
                    REF (u)
                FROM
                    Users u
                WHERE
                    u.user_id = 7
            )
        )
    );

INSERT INTO
    Posts
VALUES
    (
        PostType (
            post_id_seq.NEXTVAL,
            'Quick healthy lunch ideas for busy professionals 🥗',
            TIMESTAMP '2024-03-15 12:30:00',
            (
                SELECT
                    REF (u)
                FROM
                    Users u
                WHERE
                    u.user_id = 7
            )
        )
    );

-- Less active users (eco_peter - ID 13, scientist_alan - ID 16)
INSERT INTO
    Posts
VALUES
    (
        PostType (
            post_id_seq.NEXTVAL,
            'Monthly update: Our beach cleanup collected 500kg of plastic! 🌊 #SaveTheOceans',
            TIMESTAMP '2024-03-15 16:00:00',
            (
                SELECT
                    REF (u)
                FROM
                    Users u
                WHERE
                    u.user_id = 13
            )
        )
    );

INSERT INTO
    Posts
VALUES
    (
        PostType (
            post_id_seq.NEXTVAL,
            'New research paper published on quantum computing applications in cryptography',
            TIMESTAMP '2024-03-15 14:00:00',
            (
                SELECT
                    REF (u)
                FROM
                    Users u
                WHERE
                    u.user_id = 16
            )
        )
    );

-- gamer_sam posts (User ID: 11) - Very active gaming influencer
INSERT INTO
    Posts
VALUES
    (
        PostType (
            post_id_seq.NEXTVAL,
            'Live now! Streaming the new RPG release! Come join! 🎮 #Gaming #LiveStream',
            TIMESTAMP '2024-03-15 20:00:00',
            (
                SELECT
                    REF (u)
                FROM
                    Users u
                WHERE
                    u.user_id = 11
            )
        )
    );

INSERT INTO
    Posts
VALUES
    (
        PostType (
            post_id_seq.NEXTVAL,
            'Game Review: 10 things you need to know about the latest release! 🎮',
            TIMESTAMP '2024-03-15 15:30:00',
            (
                SELECT
                    REF (u)
                FROM
                    Users u
                WHERE
                    u.user_id = 11
            )
        )
    );

INSERT INTO
    Posts
VALUES
    (
        PostType (
            post_id_seq.NEXTVAL,
            'My gaming setup tour! New RGB lighting installed! ✨ #GamingSetup',
            TIMESTAMP '2024-03-15 12:45:00',
            (
                SELECT
                    REF (u)
                FROM
                    Users u
                WHERE
                    u.user_id = 11
            )
        )
    );

-- fashion_nina posts (User ID: 14) - Very active fashion influencer
INSERT INTO
    Posts
VALUES
    (
        PostType (
            post_id_seq.NEXTVAL,
            'Spring Fashion Haul! 👗 Swipe to see my favorite picks! #FashionBlogger',
            TIMESTAMP '2024-03-15 11:00:00',
            (
                SELECT
                    REF (u)
                FROM
                    Users u
                WHERE
                    u.user_id = 14
            )
        )
    );

INSERT INTO
    Posts
VALUES
    (
        PostType (
            post_id_seq.NEXTVAL,
            'How to style one dress in 5 different ways! 💃 #StyleTips',
            TIMESTAMP '2024-03-15 14:30:00',
            (
                SELECT
                    REF (u)
                FROM
                    Users u
                WHERE
                    u.user_id = 14
            )
        )
    );

INSERT INTO
    Posts
VALUES
    (
        PostType (
            post_id_seq.NEXTVAL,
            'GRWM: Fashion Week Edition! 👠 #FashionWeek #OOTD',
            TIMESTAMP '2024-03-15 17:15:00',
            (
                SELECT
                    REF (u)
                FROM
                    Users u
                WHERE
                    u.user_id = 14
            )
        )
    );

-- Additional random posts with varying dates and content
-- Tech posts from different users
INSERT INTO
    Posts
VALUES
    (
        PostType (
            post_id_seq.NEXTVAL,
            'Learning React Native for mobile development. Any tips? 📱 #coding #mobiledev',
            TIMESTAMP '2024-03-14 15:30:00',
            (
                SELECT
                    REF (u)
                FROM
                    Users u
                WHERE
                    u.user_id = 6
            )
        )
    );

INSERT INTO
    Posts
VALUES
    (
        PostType (
            post_id_seq.NEXTVAL,
            'Exploring machine learning algorithms for my latest project 🤖 #AI #ML',
            TIMESTAMP '2024-03-13 10:45:00',
            (
                SELECT
                    REF (u)
                FROM
                    Users u
                WHERE
                    u.user_id = 16
            )
        )
    );

-- Fitness and Health posts
INSERT INTO
    Posts
VALUES
    (
        PostType (
            post_id_seq.NEXTVAL,
            '5k morning run completed! New personal best! 🏃‍♀️ #Running #Fitness',
            TIMESTAMP '2024-03-14 07:15:00',
            (
                SELECT
                    REF (u)
                FROM
                    Users u
                WHERE
                    u.user_id = 7
            )
        )
    );

INSERT INTO
    Posts
VALUES
    (
        PostType (
            post_id_seq.NEXTVAL,
            'Post-workout protein smoothie recipe! Banana + Peanut butter = 😋 #HealthyLiving',
            TIMESTAMP '2024-03-13 16:20:00',
            (
                SELECT
                    REF (u)
                FROM
                    Users u
                WHERE
                    u.user_id = 20
            )
        )
    );

-- Travel content
INSERT INTO
    Posts
VALUES
    (
        PostType (
            post_id_seq.NEXTVAL,
            'Sunset in Bali 🌅 Sometimes you need to get lost to find yourself #Travel',
            TIMESTAMP '2024-03-12 18:30:00',
            (
                SELECT
                    REF (u)
                FROM
                    Users u
                WHERE
                    u.user_id = 10
            )
        )
    );

-- Art and creativity
INSERT INTO
    Posts
VALUES
    (
        PostType (
            post_id_seq.NEXTVAL,
            'New digital art piece finished! Swipe to see the process 🎨 #DigitalArt',
            TIMESTAMP '2024-03-11 14:20:00',
            (
                SELECT
                    REF (u)
                FROM
                    Users u
                WHERE
                    u.user_id = 9
            )
        )
    );

-- Food and cooking
INSERT INTO
    Posts
VALUES
    (
        PostType (
            post_id_seq.NEXTVAL,
            'Homemade sushi night! 🍣 Tutorial coming soon! #Cooking #FoodLover',
            TIMESTAMP '2024-03-10 19:15:00',
            (
                SELECT
                    REF (u)
                FROM
                    Users u
                WHERE
                    u.user_id = 8
            )
        )
    );

-- Gaming content
INSERT INTO
    Posts
VALUES
    (
        PostType (
            post_id_seq.NEXTVAL,
            'Just hit Diamond rank! The grind was worth it 🎮 #Gaming #ESports',
            TIMESTAMP '2024-03-09 22:30:00',
            (
                SELECT
                    REF (u)
                FROM
                    Users u
                WHERE
                    u.user_id = 11
            )
        )
    );

-- Environmental awareness
INSERT INTO
    Posts
VALUES
    (
        PostType (
            post_id_seq.NEXTVAL,
            'Simple ways to reduce your carbon footprint 🌍 Thread below! #Environment',
            TIMESTAMP '2024-03-08 11:45:00',
            (
                SELECT
                    REF (u)
                FROM
                    Users u
                WHERE
                    u.user_id = 13
            )
        )
    );

-- Music related
INSERT INTO
    Posts
VALUES
    (
        PostType (
            post_id_seq.NEXTVAL,
            'New cover song dropping tomorrow! Stay tuned 🎵 #Music #Singer',
            TIMESTAMP '2024-03-07 20:00:00',
            (
                SELECT
                    REF (u)
                FROM
                    Users u
                WHERE
                    u.user_id = 12
            )
        )
    );

-- Fashion posts
INSERT INTO
    Posts
VALUES
    (
        PostType (
            post_id_seq.NEXTVAL,
            'Summer fashion trends 2024 prediction 👗 #Fashion #Style',
            TIMESTAMP '2024-03-06 13:15:00',
            (
                SELECT
                    REF (u)
                FROM
                    Users u
                WHERE
                    u.user_id = 14
            )
        )
    );

-- Pet content
INSERT INTO
    Posts
VALUES
    (
        PostType (
            post_id_seq.NEXTVAL,
            'Meet our newest rescue puppy! 🐕 Help us name him! #AdoptDontShop',
            TIMESTAMP '2024-03-05 16:40:00',
            (
                SELECT
                    REF (u)
                FROM
                    Users u
                WHERE
                    u.user_id = 19
            )
        )
    );

-- DIY content
INSERT INTO
    Posts
VALUES
    (
        PostType (
            post_id_seq.NEXTVAL,
            'Transformed this $10 thrift store find into a stunning piece! Before and After pics 🎨 #DIY #Upcycling',
            TIMESTAMP '2024-03-04 15:20:00',
            (
                SELECT
                    REF (u)
                FROM
                    Users u
                WHERE
                    u.user_id = 17
            )
        )
    );

INSERT INTO
    Posts
VALUES
    (
        PostType (
            post_id_seq.NEXTVAL,
            'Just finished the first draft of my new novel! 📚 Six months of work finally paying off! #AmWriting',
            TIMESTAMP '2024-03-14 23:45:00',
            (
                SELECT
                    REF (u)
                FROM
                    Users u
                WHERE
                    u.user_id = 13
            )
        )
    );

INSERT INTO
    Posts
VALUES
    (
        PostType (
            post_id_seq.NEXTVAL,
            'Book Review: "The Midnight Library" - A masterpiece that makes you question every life choice 📖 #BookReview',
            TIMESTAMP '2024-03-13 16:30:00',
            (
                SELECT
                    REF (u)
                FROM
                    Users u
                WHERE
                    u.user_id = 13
            )
        )
    );

INSERT INTO
    Posts
VALUES
    (
        PostType (
            post_id_seq.NEXTVAL,
            'New choreography sneak peek! 💃 Contemporary piece coming to the studio next week #DanceLife',
            TIMESTAMP '2024-03-15 19:20:00',
            (
                SELECT
                    REF (u)
                FROM
                    Users u
                WHERE
                    u.user_id = 15
            )
        )
    );

INSERT INTO
    Posts
VALUES
    (
        PostType (
            post_id_seq.NEXTVAL,
            'Behind the scenes at today''s dance rehearsal! Preparing for the summer showcase 🎭 #DancerLife',
            TIMESTAMP '2024-03-14 14:15:00',
            (
                SELECT
                    REF (u)
                FROM
                    Users u
                WHERE
                    u.user_id = 15
            )
        )
    );

INSERT INTO
    Posts
VALUES
    (
        PostType (
            post_id_seq.NEXTVAL,
            'Big news! Our startup just secured Series A funding! 🚀 Grateful for the amazing team! #StartupLife',
            TIMESTAMP '2024-03-15 10:30:00',
            (
                SELECT
                    REF (u)
                FROM
                    Users u
                WHERE
                    u.user_id = 14
            )
        )
    );

INSERT INTO
    Posts
VALUES
    (
        PostType (
            post_id_seq.NEXTVAL,
            'The future of AI in healthcare - My thoughts on recent developments and what''s coming next 🤖 #HealthTech',
            TIMESTAMP '2024-03-13 11:45:00',
            (
                SELECT
                    REF (u)
                FROM
                    Users u
                WHERE
                    u.user_id = 14
            )
        )
    );

INSERT INTO
    Posts
VALUES
    (
        PostType (
            post_id_seq.NEXTVAL,
            'Dawn at Mount Fuji. Sometimes waking up at 4AM is worth it 📸 #Photography #Nature',
            TIMESTAMP '2024-03-15 05:30:00',
            (
                SELECT
                    REF (u)
                FROM
                    Users u
                WHERE
                    u.user_id = 12
            )
        )
    );

INSERT INTO
    Posts
VALUES
    (
        PostType (
            post_id_seq.NEXTVAL,
            'Photography Workshop Announcement! Learn night photography techniques this weekend 🌙 #PhotoWorkshop',
            TIMESTAMP '2024-03-14 12:00:00',
            (
                SELECT
                    REF (u)
                FROM
                    Users u
                WHERE
                    u.user_id = 12
            )
        )
    );

INSERT INTO
    Posts
VALUES
    (
        PostType (
            post_id_seq.NEXTVAL,
            'Championship game highlights! Proud coach moment - our team brought home the trophy! 🏆 #Sports',
            TIMESTAMP '2024-03-15 21:00:00',
            (
                SELECT
                    REF (u)
                FROM
                    Users u
                WHERE
                    u.user_id = 20
            )
        )
    );

INSERT INTO
    Posts
VALUES
    (
        PostType (
            post_id_seq.NEXTVAL,
            'Quick agility drill tutorial 🏃‍♂️ Save this for your next training session! #SportsTraining',
            TIMESTAMP '2024-03-14 16:45:00',
            (
                SELECT
                    REF (u)
                FROM
                    Users u
                WHERE
                    u.user_id = 20
            )
        )
    );

INSERT INTO
    Posts
VALUES
    (
        PostType (
            post_id_seq.NEXTVAL,
            'Transformed this $10 thrift store find into a stunning piece! Before and  After pics 🎨 #DIY #Upcycling',
            TIMESTAMP '2024-03-15 13:20:00',
            (
                SELECT
                    REF (u)
                FROM
                    Users u
                WHERE
                    u.user_id = 17
            )
        )
    );

INSERT INTO
    Posts
VALUES
    (
        PostType (
            post_id_seq.NEXTVAL,
            'Easy weekend project: Making your own macramé wall hanging! Tutorial in comments 🧶 #DIYHome',
            TIMESTAMP '2024-03-13 14:30:00',
            (
                SELECT
                    REF (u)
                FROM
                    Users u
                WHERE
                    u.user_id = 17
            )
        )
    );

INSERT INTO
    Posts
VALUES
    (
        PostType (
            post_id_seq.NEXTVAL,
            'Tonight''s show was EPIC! Thanks NYC for the amazing energy! 🎤 Next stop: Chicago! #StandUpComedy',
            TIMESTAMP '2024-03-15 23:45:00',
            (
                SELECT
                    REF (u)
                FROM
                    Users u
                WHERE
                    u.user_id = 18 
            )
        )
    );

INSERT INTO
    Posts
VALUES
    (
        PostType (
            post_id_seq.NEXTVAL,
            'When your mom says "we have food at home" 😂 #ComedySketch #Relatable',
            TIMESTAMP '2024-03-14 17:30:00',
            (
                SELECT
                    REF (u)
                FROM
                    Users u
                WHERE
                    u.user_id = 18
            )
        )
    );

INSERT INTO
    Posts
VALUES
    (
        PostType (
            post_id_seq.NEXTVAL,
            'Successful adoption day at the shelter! 15 pets found their forever homes today! ❤️ #AdoptDontShop',
            TIMESTAMP '2024-03-15 18:15:00',
            (
                SELECT
                    REF (u)
                FROM
                    Users u
                WHERE
                    u.user_id = 19
            )
        )
    );

INSERT INTO
    Posts
VALUES
    (
        PostType (
            post_id_seq.NEXTVAL,
            'Essential tips for first-time cat owners! 🐱 Save this post for later! #PetCare #CatLover',
            TIMESTAMP '2024-03-14 13:45:00',
            (
                SELECT
                    REF (u)
                FROM
                    Users u
                WHERE
                    u.user_id = 19
            )
        )
    );

COMMIT;

-- Get total post count
SELECT COUNT(*) AS total_posts 
FROM Posts;



