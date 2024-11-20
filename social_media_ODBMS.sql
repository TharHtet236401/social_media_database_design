-- Drop sequences if they exist
DROP SEQUENCE message_id_seq;

DROP SEQUENCE like_id_seq;

DROP SEQUENCE comment_id_seq;

DROP SEQUENCE post_id_seq;

DROP SEQUENCE user_id_seq;

-- Drop tables if they exist
DROP TABLE Messages;

DROP TABLE Likes;

DROP TABLE Comments;

DROP TABLE Posts;

DROP TABLE Users;

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
    profile_picture VARCHAR2 (500)
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
    content VARCHAR2(4000),
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
    content VARCHAR2(4000),
    created_at TIMESTAMP,
    user_ref REF UserType,
    post_ref REF PostType
);

/
-- Message object type for private communication
CREATE
OR REPLACE TYPE MessageType AS OBJECT (
    message_id NUMBER,
    content VARCHAR2(4000),
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
        password_hash NOT NULL
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
INSERT INTO Users VALUES (
    AdminType(
        user_id_seq.NEXTVAL,
        'admin_sarah',
        'sarah.admin@platform.com',
        'hashed_admin_pwd_1',
        TIMESTAMP '2023-01-01 09:00:00',
        'admin_profiles/sarah.jpg',
        1001,
        250,
        TIMESTAMP '2024-03-15 14:30:00',
        1
    )
);
--admin 2
INSERT INTO Users VALUES (
    AdminType(
        user_id_seq.NEXTVAL,
        'admin_michael',
        'michael.admin@platform.com',
        'hashed_admin_pwd_2',
        TIMESTAMP '2023-01-02 10:00:00',
        'admin_profiles/michael.jpg',
        1002,
        180,
        TIMESTAMP '2024-03-15 16:45:00',
        2
    )
);
--admin 3
INSERT INTO Users VALUES (
    AdminType(
        user_id_seq.NEXTVAL,
        'admin_jessica',
        'jessica.admin@platform.com',
        'hashed_admin_pwd_3',
        TIMESTAMP '2023-01-03 11:00:00',
        'admin_profiles/jessica.jpg',
        1003,
        320,
        TIMESTAMP '2024-03-15 15:20:00',
        1
    )
);
--admin 4
INSERT INTO Users VALUES (
    AdminType(
        user_id_seq.NEXTVAL,
        'admin_david',
        'david.admin@platform.com',
        'hashed_admin_pwd_4',
        TIMESTAMP '2023-01-04 12:00:00',
        'admin_profiles/david.jpg',
        1004,
        290,
        TIMESTAMP '2024-03-15 17:10:00',
        2
    )
);
--admin 5
INSERT INTO Users VALUES (
    AdminType(
        user_id_seq.NEXTVAL,
        'admin_emma',
        'emma.admin@platform.com',
        'hashed_admin_pwd_5',
        TIMESTAMP '2023-01-05 13:00:00',
        'admin_profiles/emma.jpg',
        1005,
        275,
        TIMESTAMP '2024-03-15 18:00:00',
        1
    )
);

-- Insert Regular Users with adjusted follower/following counts (max 20)
--user 1
INSERT INTO Users VALUES (
    RegularUserType(
        user_id_seq.NEXTVAL,
        'tech_guru_alex',
        'alex@email.com',
        'hashed_pwd_1',
        TIMESTAMP '2023-02-01 10:00:00',
        'profiles/alex.jpg',
        'Software Developer | AI Enthusiast | Coffee Lover',
        'Coding something cool',
        15,
        12
    )
);
--user 2
INSERT INTO Users VALUES (
    RegularUserType(
        user_id_seq.NEXTVAL,
        'fitness_jane',
        'jane@email.com',
        'hashed_pwd_2',
        TIMESTAMP '2023-02-02 11:00:00',
        'profiles/jane.jpg',
        'Personal Trainer | Nutrition Expert',
        'At the gym 💪',
        18,
        15
    )
);
--user 3
INSERT INTO Users VALUES (
    RegularUserType(
        user_id_seq.NEXTVAL,
        'foodie_mark',
        'mark@email.com',
        'hashed_pwd_3',
        TIMESTAMP '2023-02-03 12:00:00',
        'profiles/mark.jpg',
        'Food Blogger | Chef | Restaurant Explorer',
        'Cooking up something special',
        20,
        17
    )
);
--user 4
INSERT INTO Users VALUES (
    RegularUserType(
        user_id_seq.NEXTVAL,
        'artist_lisa',
        'lisa@email.com',
        'hashed_pwd_4',
        TIMESTAMP '2023-02-04 13:00:00',
        'profiles/lisa.jpg',
        'Digital Artist | Illustrator',
        'Creating new artwork',
        16,
        14
    )
);
--user 5
INSERT INTO Users VALUES (
    RegularUserType(
        user_id_seq.NEXTVAL,
        'travel_mike',
        'mike@email.com',
        'hashed_pwd_5',
        TIMESTAMP '2023-02-05 14:00:00',
        'profiles/mike.jpg',
        'World Traveler | Photographer',
        'Exploring new places',
        19,
        16
    )
);
--user 6
INSERT INTO Users VALUES (
    RegularUserType(
        user_id_seq.NEXTVAL,
        'gamer_sam',
        'sam@email.com',
        'hashed_pwd_6',
        TIMESTAMP '2023-02-06 15:00:00',
        'profiles/sam.jpg',
        'Professional Gamer | Streamer',
        'Live streaming now!',
        20,
        18
    )
);
--user 7
INSERT INTO Users VALUES (
    RegularUserType(
        user_id_seq.NEXTVAL,
        'music_rachel',
        'rachel@email.com',
        'hashed_pwd_7',
        TIMESTAMP '2023-02-07 16:00:00',
        'profiles/rachel.jpg',
        'Singer | Songwriter | Producer',
        'Making music 🎵',
        17,
        15
    )
);
--user 8
INSERT INTO Users VALUES (
    RegularUserType(
        user_id_seq.NEXTVAL,
        'eco_peter',
        'peter@email.com',
        'hashed_pwd_8',
        TIMESTAMP '2023-02-08 17:00:00',
        'profiles/peter.jpg',
        'Environmental Activist | Sustainable Living',
        'Saving the planet 🌍',
        14,
        12
    )
);
--user 9
INSERT INTO Users VALUES (
    RegularUserType(
        user_id_seq.NEXTVAL,
        'fashion_nina',
        'nina@email.com',
        'hashed_pwd_9',
        TIMESTAMP '2023-02-09 18:00:00',
        'profiles/nina.jpg',
        'Fashion Blogger | Style Consultant',
        'Fashion week ready',
        20,
        16
    )
);
--user 10
INSERT INTO Users VALUES (
    RegularUserType(
        user_id_seq.NEXTVAL,
        'chef_carlos',
        'carlos@email.com',
        'hashed_pwd_10',
        TIMESTAMP '2023-02-10 19:00:00',
        'profiles/carlos.jpg',
        'Professional Chef | Food Photography',
        'In the kitchen',
        18,
        15
    )
);
--user 11
INSERT INTO Users VALUES (
    RegularUserType(
        user_id_seq.NEXTVAL,
        'yoga_emma',
        'emma.y@email.com',
        'hashed_pwd_11',
        TIMESTAMP '2023-02-11 20:00:00',
        'profiles/emma_y.jpg',
        'Yoga Instructor | Mindfulness Coach',
        'Namaste 🧘‍♀️',
        16,
        13
    )
);
--user 12
INSERT INTO Users VALUES (
    RegularUserType(
        user_id_seq.NEXTVAL,
        'photographer_tom',
        'tom@email.com',
        'hashed_pwd_12',
        TIMESTAMP '2023-02-12 21:00:00',
        'profiles/tom.jpg',
        'Professional Photographer | Nature Lover',
        'Capturing moments',
        19,
        17
    )
);
--user 13
INSERT INTO Users VALUES (
    RegularUserType(
        user_id_seq.NEXTVAL,
        'writer_sophia',
        'sophia@email.com',
        'hashed_pwd_13',
        TIMESTAMP '2023-02-13 22:00:00',
        'profiles/sophia.jpg',
        'Author | Book Reviewer | Coffee Addict',
        'Writing my next novel',
        15,
        14
    )
);
--user 14
INSERT INTO Users VALUES (
    RegularUserType(
        user_id_seq.NEXTVAL,
        'startup_ryan',
        'ryan@email.com',
        'hashed_pwd_14',
        TIMESTAMP '2023-02-14 23:00:00',
        'profiles/ryan.jpg',
        'Entrepreneur | Tech Startup Founder',
        'Building the future',
        20,
        15
    )
);
--user 15
INSERT INTO Users VALUES (
    RegularUserType(
        user_id_seq.NEXTVAL,
        'dancer_maria',
        'maria@email.com',
        'hashed_pwd_15',
        TIMESTAMP '2023-02-15 00:00:00',
        'profiles/maria.jpg',
        'Professional Dancer | Dance Instructor',
        'Dancing through life 💃',
        18,
        16
    )
);
--user 16
INSERT INTO Users VALUES (
    RegularUserType(
        user_id_seq.NEXTVAL,
        'scientist_alan',
        'alan@email.com',
        'hashed_pwd_16',
        TIMESTAMP '2023-02-16 01:00:00',
        'profiles/alan.jpg',
        'Research Scientist | Physics Enthusiast',
        'Exploring the universe',
        13,
        11
    )
);
--user 17
INSERT INTO Users VALUES (
    RegularUserType(
        user_id_seq.NEXTVAL,
        'diy_hannah',
        'hannah@email.com',
        'hashed_pwd_17',
        TIMESTAMP '2023-02-17 02:00:00',
        'profiles/hannah.jpg',
        'DIY Expert | Home Improvement',
        'Creating something new',
        17,
        14
    )
);
--user 18
INSERT INTO Users VALUES (
    RegularUserType(
        user_id_seq.NEXTVAL,
        'comedian_jack',
        'jack@email.com',
        'hashed_pwd_18',
        TIMESTAMP '2023-02-18 03:00:00',
        'profiles/jack.jpg',
        'Stand-up Comedian | Content Creator',
        'Making people laugh 😂',
        20,
        18
    )
);
--user 19
INSERT INTO Users VALUES (
    RegularUserType(
        user_id_seq.NEXTVAL,
        'pet_lover_lucy',
        'lucy@email.com',
        'hashed_pwd_19',
        TIMESTAMP '2023-02-19 04:00:00',
        'profiles/lucy.jpg',
        'Pet Influencer | Animal Rescue Advocate',
        'Playing with puppies 🐕',
        19,
        16
    )
);
--user 20
INSERT INTO Users VALUES (
    RegularUserType(
        user_id_seq.NEXTVAL,
        'sports_coach_ben',
        'ben@email.com',
        'hashed_pwd_20',
        TIMESTAMP '2023-02-20 05:00:00',
        'profiles/ben.jpg',
        'Sports Coach | Fitness Expert',
        'Training champions',
        17,
        15
    )
);

COMMIT;
