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
    created_at DATE
) NOT FINAL;

/
-- Admin object type inheriting from UserType
CREATE
OR REPLACE TYPE AdminType UNDER UserType (
    admin_id NUMBER,
    reports_viewed NUMBER,
    last_login DATE,
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
    created_at DATE,
    user_ref REF UserType
);

/
-- Like object type
CREATE
OR REPLACE TYPE LikeType AS OBJECT (
    like_id NUMBER,
    user_ref REF UserType,
    post_ref REF PostType,
    created_at DATE
);

/
-- Comment object type
CREATE
OR REPLACE TYPE CommentType AS OBJECT (
    comment_id NUMBER,
    content CLOB,
    created_at DATE,
    user_ref REF UserType,
    post_ref REF PostType
);

/
-- Message object type for private communication
CREATE
OR REPLACE TYPE MessageType AS OBJECT (
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

SELECT VALUE(u) FROM Users u;

Select 
u.username,
u.email,
u.created_at,
u.password_hash,
TREAT(VALUE(u) AS AdminType).admin_id,
TREAT(VALUE(u) AS AdminType).reports_viewed,
TREAT(VALUE(u) AS AdminType).last_login,
TREAT(VALUE(u) AS AdminType).admin_level
FROM Users u;


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


