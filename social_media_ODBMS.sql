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
CREATE OR REPLACE TYPE UserType AS OBJECT (
    user_id NUMBER,
    username VARCHAR2(50),
    email VARCHAR2(100),
    password_hash VARCHAR2(255),
    created_at DATE
) NOT FINAL;
/

-- Admin object type inheriting from UserType
CREATE OR REPLACE TYPE AdminType UNDER UserType (
    admin_id NUMBER,
    reports_viewed NUMBER,
    last_login DATE,
    admin_level NUMBER
);
/

-- RegularUser object type inheriting from UserType
CREATE OR REPLACE TYPE RegularUserType UNDER UserType (
    profile_picture VARCHAR2(500),
    bio VARCHAR2(4000),
    user_status VARCHAR2(255),
    followers NUMBER,
    following NUMBER
);
/


-- Post object type
CREATE OR REPLACE TYPE PostType AS OBJECT (
    post_id NUMBER,
    content CLOB,
    created_at DATE,        
    user_ref REF UserType
);
/

-- Like object type
CREATE OR REPLACE TYPE LikeType AS OBJECT (
    like_id NUMBER,
    user_ref REF UserType,
    post_ref REF PostType,
    created_at DATE
);
/

-- Comment object type
CREATE OR REPLACE TYPE CommentType AS OBJECT (
    comment_id NUMBER,
    content CLOB,
    created_at DATE,
    user_ref REF UserType,
    post_ref REF PostType
);
/


-- Message object type for private communication
CREATE OR REPLACE TYPE MessageType AS OBJECT (
    message_id NUMBER,
    content CLOB,
    sent_at DATE,
    sender_ref REF UserType,
    receiver_ref REF UserType
);
/
COMMIT;
-- Finished creating types for the database

-- Creating tables for the database

-- Users table (Object table of UserType)
CREATE TABLE Users OF UserType (
    user_id PRIMARY KEY,
    username UNIQUE NOT NULL,
    email UNIQUE NOT NULL,
    password_hash NOT NULL
) 

-- Posts table (Object table of PostType)
CREATE TABLE Posts OF PostType (
    post_id PRIMARY KEY,
    content NOT NULL,
    created_at NOT NULL,
    user_ref SCOPE IS Users NOT NULL
) 

-- Comments table (Object table of CommentType)
CREATE TABLE Comments OF CommentType (
    comment_id PRIMARY KEY,
    content NOT NULL,
    created_at NOT NULL,
    user_ref SCOPE IS Users NOT NULL,
    post_ref SCOPE IS Posts NOT NULL
) 

-- Likes table (Object table of LikeType)
CREATE TABLE Likes OF LikeType (
    like_id PRIMARY KEY,
    created_at NOT NULL,
    user_ref SCOPE IS Users NOT NULL,
    post_ref SCOPE IS Posts NOT NULL
)

-- Messages table (Object table of MessageType)
CREATE TABLE Messages OF MessageType (
    message_id PRIMARY KEY,
    content NOT NULL,
    sent_at NOT NULL,
    sender_ref SCOPE IS Users NOT NULL,
    receiver_ref SCOPE IS Users NOT NULL
) 

-- Create sequences for generating IDs
CREATE SEQUENCE user_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE post_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE comment_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE like_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE message_id_seq START WITH 1 INCREMENT BY 1;




