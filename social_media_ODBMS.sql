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
    created_at TIMESTAMP
) NOT FINAL;

/
-- Admin object type inheriting from UserType
CREATE
OR REPLACE TYPE AdminType UNDER UserType (
    admin_id NUMBER,
    reports_viewed NUMBER,
    last_login TIMESTAMP,
    admin_level NUMBER
);

/
-- RegularUser object type inheriting from UserType
CREATE
OR REPLACE TYPE RegularUserType UNDER UserType (
    profile_picture VARCHAR2 (500),
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
    content CLOB,
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
    content CLOB,
    created_at TIMESTAMP,
    user_ref REF UserType,
    post_ref REF PostType
);

/
-- Message object type for private communication
CREATE
OR REPLACE TYPE MessageType AS OBJECT (
    message_id NUMBER,
    content CLOB,
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
INSERT INTO Users VALUES (
    AdminType(
        user_id_seq.NEXTVAL,
        'admin1',
        'admin1@example.com', 
        'hashed_password_1',
        TO_DATE('23-JAN-2005','DD-MM-YYYY'),
        1001,
        0,
        TO_DATE('15-MAR-2005','DD-MM-YYYY'),
        1
    )
);

INSERT INTO Users VALUES (
    AdminType(
        user_id_seq.NEXTVAL,
        'admin2',
        'admin2@example.com',
        'hashed_password_2', 
        TO_DATE('07-JUN-2005','DD-MM-YYYY'),
        1002,
        5,
        TO_DATE('12-SEP-2005','DD-MM-YYYY'),
        2
    )
);

INSERT INTO Users VALUES (
    AdminType(
        user_id_seq.NEXTVAL,
        'superadmin',
        'superadmin@example.com',
        'hashed_password_3',
        TO_DATE('30-NOV-2005','DD-MM-YYYY'),
        1003,
        25,
        TO_DATE('25-DEC-2005','DD-MM-YYYY'),
        3
    )
);

-- Insert regular users
INSERT INTO Users VALUES (
    RegularUserType(
        user_id_seq.NEXTVAL,
        'regularuser1',
        'user1@example.com',
        'hashed_password_4',
        TO_DATE('15-DEC-2005','DD-MM-YYYY'),
        'profile_picture_url',
        'bio_text',
        'user_status',
        100,
        100
    )
);

INSERT INTO Users VALUES (
    RegularUserType(
        user_id_seq.NEXTVAL,
        'regularuser2', 
        'user2@example.com',
        'hashed_password_5',
        TO_DATE('16-DEC-2005','DD-MM-YYYY'),
        'profile_picture_url',
        'bio_text',
        'user_status',
        200,
        150
    )
);

INSERT INTO Users VALUES (
    RegularUserType(
        user_id_seq.NEXTVAL,
        'regularuser3',
        'user3@example.com',
        'hashed_password_6',
        TO_DATE('17-DEC-2005','DD-MM-YYYY'),
        'profile_picture_url',
        'bio_text',
        'user_status',
        300,
        250
    )
);

INSERT INTO Users VALUES (
    RegularUserType(
        user_id_seq.NEXTVAL,
        'techie_sarah',
        'sarah@example.com',
        'hashed_password_7',
        TO_DATE('18-DEC-2005','DD-MM-YYYY'),
        'profile_pic_sarah.jpg',
        'Tech enthusiast | Coffee lover | Code warrior',
        'Coding away...',
        150,
        120
    )
);

INSERT INTO Users VALUES (
    RegularUserType(
        user_id_seq.NEXTVAL,
        'adventure_mike',
        'mike@example.com',
        'hashed_password_8',
        TO_DATE('19-DEC-2005','DD-MM-YYYY'),
        'profile_pic_mike.jpg',
        'Travel | Photography | Nature',
        'Exploring the world',
        280,
        200
    )
);

INSERT INTO Users VALUES (
    RegularUserType(
        user_id_seq.NEXTVAL,
        'foodie_emma',
        'emma@example.com',
        'hashed_password_9',
        TO_DATE('20-DEC-2005','DD-MM-YYYY'),
        'profile_pic_emma.jpg',
        'Food blogger | Recipe developer',
        'Cooking up something delicious',
        450,
        380
    )
);

INSERT INTO Users VALUES (
    RegularUserType(
        user_id_seq.NEXTVAL,
        'fitness_alex',
        'alex@example.com',
        'hashed_password_10',
        TO_DATE('21-DEC-2005','DD-MM-YYYY'),
        'profile_pic_alex.jpg',
        'Personal trainer | Wellness coach',
        'At the gym',
        600,
        520
    )
);

INSERT INTO Users VALUES (
    RegularUserType(
        user_id_seq.NEXTVAL,
        'artist_lisa',
        'lisa@example.com',
        'hashed_password_11',
        TO_DATE('22-DEC-2005','DD-MM-YYYY'),
        'profile_pic_lisa.jpg',
        'Digital artist | Illustrator',
        'Creating new artwork',
        750,
        680
    )
);

INSERT INTO Users VALUES (
    RegularUserType(
        user_id_seq.NEXTVAL,
        'gamer_dave',
        'dave@example.com',
        'hashed_password_12',
        TO_DATE('23-DEC-2005','DD-MM-YYYY'),
        'profile_pic_dave.jpg',
        'Professional gamer | Streamer',
        'Live streaming',
        1200,
        800
    )
);

INSERT INTO Users VALUES (
    RegularUserType(
        user_id_seq.NEXTVAL,
        'bookworm_nina',
        'nina@example.com',
        'hashed_password_13',
        TO_DATE('24-DEC-2005','DD-MM-YYYY'),
        'profile_pic_nina.jpg',
        'Book reviewer | Literature lover',
        'Reading my next book',
        320,
        290
    )
);

INSERT INTO Users VALUES (
    RegularUserType(
        user_id_seq.NEXTVAL,
        'music_tom',
        'tom@example.com',
        'hashed_password_14',
        TO_DATE('25-DEC-2005','DD-MM-YYYY'),
        'profile_pic_tom.jpg',
        'Musician | Producer',
        'Making music',
        890,
        760
    )
);

INSERT INTO Users VALUES (
    RegularUserType(
        user_id_seq.NEXTVAL,
        'eco_julia',
        'julia@example.com',
        'hashed_password_15',
        TO_DATE('26-DEC-2005','DD-MM-YYYY'),
        'profile_pic_julia.jpg',
        'Environmental activist | Sustainable living',
        'Saving the planet',
        420,
        380
    )
);

--insert posts
INSERT INTO Posts VALUES (
    
        post_id_seq.NEXTVAL,
        'This is my first post! Hello social media world!',
        TO_DATE('15-DEC-2005','DD-MM-YYYY'),
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser1')
    
);

INSERT INTO Posts VALUES (
    
        post_id_seq.NEXTVAL,
        'Sharing some thoughts about technology and social media...',
        TO_DATE('16-DEC-2005','DD-MM-YYYY'),
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser1')
    
);

INSERT INTO Posts VALUES (
   
        post_id_seq.NEXTVAL,
        'Just had an amazing day! Wanted to share with everyone.',
        TO_DATE('15-DEC-2005','DD-MM-YYYY'),
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser2')
    
);

INSERT INTO Posts VALUES (
    
        post_id_seq.NEXTVAL,
        'Check out this awesome new project I''m working on!',
        TO_DATE('16-DEC-2005','DD-MM-YYYY'),
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser2')
    
);

INSERT INTO Posts VALUES (
    
        post_id_seq.NEXTVAL,
        'Happy to join this platform! Looking forward to connecting with everyone.',
        TO_DATE('17-DEC-2005','DD-MM-YYYY'),
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser3')
    
);

INSERT INTO Posts VALUES (
    
        post_id_seq.NEXTVAL,
        'Sharing some interesting insights about my recent experiences...',
        TO_DATE('18-DEC-2005','DD-MM-YYYY'),
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser3')
    
);

-- Posts from techie_sarah
INSERT INTO Posts VALUES (
    post_id_seq.NEXTVAL,
    'Just deployed my first machine learning model! The possibilities are endless! #AI #coding',
    TO_DATE('18-DEC-2005','DD-MM-YYYY'),
    (SELECT REF(u) FROM Users u WHERE u.username = 'techie_sarah')
);

INSERT INTO Posts VALUES (
    post_id_seq.NEXTVAL,
    'My favorite VS Code extensions for productivity boost - thread 🧵',
    TO_DATE('19-DEC-2005','DD-MM-YYYY'),
    (SELECT REF(u) FROM Users u WHERE u.username = 'techie_sarah')
);

-- Posts from adventure_mike
INSERT INTO Posts VALUES (
    post_id_seq.NEXTVAL,
    'Sunrise at Mount Fuji - worth every step of the climb! 🗻 #Travel #Adventure',
    TO_DATE('19-DEC-2005','DD-MM-YYYY'),
    (SELECT REF(u) FROM Users u WHERE u.username = 'adventure_mike')
);

INSERT INTO Posts VALUES (
    post_id_seq.NEXTVAL,
    'Planning my next backpacking trip through South America. Any recommendations?',
    TO_DATE('20-DEC-2005','DD-MM-YYYY'),
    (SELECT REF(u) FROM Users u WHERE u.username = 'adventure_mike')
);

-- Posts from foodie_emma
INSERT INTO Posts VALUES (
    post_id_seq.NEXTVAL,
    'New recipe alert! 🍝 The perfect homemade pasta sauce - recipe in comments!',
    TO_DATE('20-DEC-2005','DD-MM-YYYY'),
    (SELECT REF(u) FROM Users u WHERE u.username = 'foodie_emma')
);

INSERT INTO Posts VALUES (
    post_id_seq.NEXTVAL,
    'Visited this amazing hidden gem restaurant in the city. Their sushi is to die for! 🍣',
    TO_DATE('21-DEC-2005','DD-MM-YYYY'),
    (SELECT REF(u) FROM Users u WHERE u.username = 'foodie_emma')
);

-- Posts from fitness_alex
INSERT INTO Posts VALUES (
    post_id_seq.NEXTVAL,
    'Quick 15-minute HIIT workout for busy professionals - swipe for exercises! 💪',
    TO_DATE('21-DEC-2005','DD-MM-YYYY'),
    (SELECT REF(u) FROM Users u WHERE u.username = 'fitness_alex')
);

INSERT INTO Posts VALUES (
    post_id_seq.NEXTVAL,
    'The importance of proper form in weightlifting - common mistakes to avoid',
    TO_DATE('22-DEC-2005','DD-MM-YYYY'),
    (SELECT REF(u) FROM Users u WHERE u.username = 'fitness_alex')
);

-- Posts from artist_lisa
INSERT INTO Posts VALUES (
    post_id_seq.NEXTVAL,
    'Just finished this digital portrait commission! Love how it turned out 🎨',
    TO_DATE('22-DEC-2005','DD-MM-YYYY'),
    (SELECT REF(u) FROM Users u WHERE u.username = 'artist_lisa')
);

INSERT INTO Posts VALUES (
    post_id_seq.NEXTVAL,
    'My creative process: from sketch to final piece - a timelapse',
    TO_DATE('23-DEC-2005','DD-MM-YYYY'),
    (SELECT REF(u) FROM Users u WHERE u.username = 'artist_lisa')
);

-- Posts from gamer_dave
INSERT INTO Posts VALUES (
    post_id_seq.NEXTVAL,
    'Epic win in today''s tournament! Thanks for all the support on the stream 🎮',
    TO_DATE('23-DEC-2005','DD-MM-YYYY'),
    (SELECT REF(u) FROM Users u WHERE u.username = 'gamer_dave')
);

INSERT INTO Posts VALUES (
    post_id_seq.NEXTVAL,
    'My thoughts on the latest game patch - what it means for competitive play',
    TO_DATE('24-DEC-2005','DD-MM-YYYY'),
    (SELECT REF(u) FROM Users u WHERE u.username = 'gamer_dave')
);

-- Posts from bookworm_nina
INSERT INTO Posts VALUES (
    post_id_seq.NEXTVAL,
    'Monthly book review: "The Midnight Library" - a journey through parallel lives 📚',
    TO_DATE('24-DEC-2005','DD-MM-YYYY'),
    (SELECT REF(u) FROM Users u WHERE u.username = 'bookworm_nina')
);

INSERT INTO Posts VALUES (
    post_id_seq.NEXTVAL,
    'My top 5 must-read books for personal development',
    TO_DATE('25-DEC-2005','DD-MM-YYYY'),
    (SELECT REF(u) FROM Users u WHERE u.username = 'bookworm_nina')
);

-- Posts from music_tom
INSERT INTO Posts VALUES (
    post_id_seq.NEXTVAL,
    'Just dropped my new track! Link in bio 🎵 #NewMusic',
    TO_DATE('25-DEC-2005','DD-MM-YYYY'),
    (SELECT REF(u) FROM Users u WHERE u.username = 'music_tom')
);

INSERT INTO Posts VALUES (
    post_id_seq.NEXTVAL,
    'Behind the scenes of my latest studio session - creating magic! 🎹',
    TO_DATE('26-DEC-2005','DD-MM-YYYY'),
    (SELECT REF(u) FROM Users u WHERE u.username = 'music_tom')
);

-- Posts from eco_julia
INSERT INTO Posts VALUES (
    post_id_seq.NEXTVAL,
    'Simple ways to reduce your plastic waste - start your eco-journey today! 🌱',
    TO_DATE('26-DEC-2005','DD-MM-YYYY'),
    (SELECT REF(u) FROM Users u WHERE u.username = 'eco_julia')
);

INSERT INTO Posts VALUES (
    post_id_seq.NEXTVAL,
    'Join us for this weekend''s beach cleanup! Together we can make a difference 🌊',
    TO_DATE('27-DEC-2005','DD-MM-YYYY'),
    (SELECT REF(u) FROM Users u WHERE u.username = 'eco_julia')
);

--insert likes 
INSERT INTO Likes VALUES (
    LikeType(
        like_id_seq.NEXTVAL,
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser1'),
        (SELECT REF(p) FROM Posts p WHERE p.post_id = 2),
        TO_DATE('16-DEC-2005','DD-MM-YYYY')
    )
);

INSERT INTO Likes VALUES (
    LikeType(
        like_id_seq.NEXTVAL,
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser2'),
        (SELECT REF(p) FROM Posts p WHERE p.post_id = 1),
        TO_DATE('16-DEC-2005','DD-MM-YYYY')
    )
);

INSERT INTO Likes VALUES (
    LikeType(
        like_id_seq.NEXTVAL,
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser3'),
        (SELECT REF(p) FROM Posts p WHERE p.post_id = 1),
        TO_DATE('17-DEC-2005','DD-MM-YYYY')
    )
);

INSERT INTO Likes VALUES (
    LikeType(
        like_id_seq.NEXTVAL,
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser1'),
        (SELECT REF(p) FROM Posts p WHERE p.post_id = 4),
        TO_DATE('17-DEC-2005','DD-MM-YYYY')
    )
);

INSERT INTO Likes VALUES (
    LikeType(
        like_id_seq.NEXTVAL,
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser2'),
        (SELECT REF(p) FROM Posts p WHERE p.post_id = 3),
        TO_DATE('18-DEC-2005','DD-MM-YYYY')
    )
);

INSERT INTO Likes VALUES (
    LikeType(
        like_id_seq.NEXTVAL,
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser3'),
        (SELECT REF(p) FROM Posts p WHERE p.post_id = 5),
        TO_DATE('18-DEC-2005','DD-MM-YYYY')
    )
);

INSERT INTO Likes VALUES (
    LikeType(
        like_id_seq.NEXTVAL,
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser1'),
        (SELECT REF(p) FROM Posts p WHERE p.post_id = 6),
        TO_DATE('19-DEC-2005','DD-MM-YYYY')
    )
);

INSERT INTO Likes VALUES (
    LikeType(
        like_id_seq.NEXTVAL,
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser2'),
        (SELECT REF(p) FROM Posts p WHERE p.post_id = 5),
        TO_DATE('19-DEC-2005','DD-MM-YYYY')
    )
);

INSERT INTO Likes VALUES (
    LikeType(
        like_id_seq.NEXTVAL,
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser3'),
        (SELECT REF(p) FROM Posts p WHERE p.post_id = 4),
        TO_DATE('20-DEC-2005','DD-MM-YYYY')
    )
);

-- insert comments
INSERT INTO Comments VALUES (
    CommentType(
        comment_id_seq.NEXTVAL,
        'Great first post! Welcome to the platform!',
        TO_DATE('15-DEC-2005','DD-MM-YYYY'),
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser2'),
        (SELECT REF(p) FROM Posts p WHERE p.post_id = 1)
    )
);

INSERT INTO Comments VALUES (
    CommentType(
        comment_id_seq.NEXTVAL,
        'Thanks for sharing! Looking forward to more posts.',
        TO_DATE('15-DEC-2005','DD-MM-YYYY'), 
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser3'),
        (SELECT REF(p) FROM Posts p WHERE p.post_id = 1)
    )
);

INSERT INTO Comments VALUES (
    CommentType(
        comment_id_seq.NEXTVAL,
        'Interesting thoughts! Would love to discuss more.',
        TO_DATE('16-DEC-2005','DD-MM-YYYY'),
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser2'),
        (SELECT REF(p) FROM Posts p WHERE p.post_id = 2)
    )
);

INSERT INTO Comments VALUES (
    CommentType(
        comment_id_seq.NEXTVAL,
        'Could you elaborate more on your thoughts about social media?',
        TO_DATE('16-DEC-2005','DD-MM-YYYY'),
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser3'),
        (SELECT REF(p) FROM Posts p WHERE p.post_id = 2)
    )
);

INSERT INTO Comments VALUES (
    CommentType(
        comment_id_seq.NEXTVAL,
        'Glad you had a great day! Share more details!',
        TO_DATE('15-DEC-2005','DD-MM-YYYY'),
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser1'),
        (SELECT REF(p) FROM Posts p WHERE p.post_id = 3)
    )
);

INSERT INTO Comments VALUES (
    CommentType(
        comment_id_seq.NEXTVAL,
        'Your positive energy is contagious!',
        TO_DATE('15-DEC-2005','DD-MM-YYYY'),
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser3'),
        (SELECT REF(p) FROM Posts p WHERE p.post_id = 3)
    )
);


--insert messages

INSERT INTO Messages VALUES (
    MessageType(
        message_id_seq.NEXTVAL,
        'Hey, how are you doing?',
        TO_DATE('15-DEC-2005','DD-MM-YYYY'),
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser1'),
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser2')
    )
);

INSERT INTO Messages VALUES (
    MessageType(
        message_id_seq.NEXTVAL,
        'I''m good! Thanks for asking. How about you?',
        TO_DATE('15-DEC-2005','DD-MM-YYYY'),
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser2'),
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser1')
    )
);

INSERT INTO Messages VALUES (
    MessageType(
        message_id_seq.NEXTVAL,
        'Did you see my latest post about the project?',
        TO_DATE('16-DEC-2005','DD-MM-YYYY'),
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser2'),
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser3')
    )
);

INSERT INTO Messages VALUES (
    MessageType(
        message_id_seq.NEXTVAL,
        'Yes, it looks amazing! Would love to collaborate',
        TO_DATE('16-DEC-2005','DD-MM-YYYY'),
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser3'),
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser2')
    )
);

INSERT INTO Messages VALUES (
    MessageType(
        message_id_seq.NEXTVAL,
        'Can we schedule a meeting to discuss the details?',
        TO_DATE('16-DEC-2005','DD-MM-YYYY'),
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser2'),
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser3')
    )
);

INSERT INTO Messages VALUES (
    MessageType(
        message_id_seq.NEXTVAL,
        'Hey! Long time no chat!',
        TO_DATE('17-DEC-2005','DD-MM-YYYY'),
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser1'),
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser3')
    )
);

INSERT INTO Messages VALUES (
    MessageType(
        message_id_seq.NEXTVAL,
        'Indeed! We should catch up soon',
        TO_DATE('17-DEC-2005','DD-MM-YYYY'),
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser3'),
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser1')
    )
);

INSERT INTO Messages VALUES (
    MessageType(
        message_id_seq.NEXTVAL,
        'Are you free this weekend?',
        TO_DATE('17-DEC-2005','DD-MM-YYYY'),
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser1'),
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser3')
    )
);

INSERT INTO Messages VALUES (
    MessageType(
        message_id_seq.NEXTVAL,
        'Yes, Saturday afternoon works for me!',
        TO_DATE('17-DEC-2005','DD-MM-YYYY'),
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser3'),
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser1')
    )
);

INSERT INTO Messages VALUES (
    MessageType(
        message_id_seq.NEXTVAL,
        'Have you started working on the new feature?',
        TO_DATE('18-DEC-2005','DD-MM-YYYY'),
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser2'),
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser1')
    )
);

INSERT INTO Messages VALUES (
    MessageType(
        message_id_seq.NEXTVAL,
        'Just getting started. Need any help?',
        TO_DATE('18-DEC-2005','DD-MM-YYYY'),
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser1'),
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser2')
    )
);

INSERT INTO Messages VALUES (
    MessageType(
        message_id_seq.NEXTVAL,
        'Could you review my code when you have time?',
        TO_DATE('18-DEC-2005','DD-MM-YYYY'),
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser2'),
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser1')
    )
);

INSERT INTO Messages VALUES (
    MessageType(
        message_id_seq.NEXTVAL,
        'Sure, send it over!',
        TO_DATE('18-DEC-2005','DD-MM-YYYY'),
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser1'),
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser2')
    )
);

INSERT INTO Messages VALUES (
    MessageType(
        message_id_seq.NEXTVAL,
        'Are we still meeting tomorrow?',
        TO_DATE('19-DEC-2005','DD-MM-YYYY'),
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser3'),
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser2')
    )
);

INSERT INTO Messages VALUES (
    MessageType(
        message_id_seq.NEXTVAL,
        'Yes, 2 PM at the usual place',
        TO_DATE('19-DEC-2005','DD-MM-YYYY'),
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser2'),
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser3')
    )
);

INSERT INTO Messages VALUES (
    MessageType(
        message_id_seq.NEXTVAL,
        'Don''t forget about the team meeting today!',
        TO_DATE('19-DEC-2005','DD-MM-YYYY'),
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser1'),
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser2')
    )
);

INSERT INTO Messages VALUES (
    MessageType(
        message_id_seq.NEXTVAL,
        'Thanks for the reminder!',
        TO_DATE('19-DEC-2005','DD-MM-YYYY'),
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser2'),
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser1')
    )
);

INSERT INTO Messages VALUES (
    MessageType(
        message_id_seq.NEXTVAL,
        'How''s the project coming along?',
        TO_DATE('20-DEC-2005','DD-MM-YYYY'),
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser3'),
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser1')
    )
);

INSERT INTO Messages VALUES (
    MessageType(
        message_id_seq.NEXTVAL,
        'Making good progress! Will share updates soon',
        TO_DATE('20-DEC-2005','DD-MM-YYYY'),
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser1'),
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser3')
    )
);

INSERT INTO Messages VALUES (
    MessageType(
        message_id_seq.NEXTVAL,
        'Let''s grab coffee sometime this week!',
        TO_DATE('20-DEC-2005','DD-MM-YYYY'),
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser2'),
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser3')
    )
);

INSERT INTO Messages VALUES (
    MessageType(
        message_id_seq.NEXTVAL,
        'Definitely! How about Wednesday?',
        TO_DATE('20-DEC-2005','DD-MM-YYYY'),
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser3'),
        (SELECT REF(u) FROM Users u WHERE u.username = 'regularuser2')
    )
);

