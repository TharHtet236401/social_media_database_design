-- Dropping existing types
DROP TYPE MessageType;
DROP TYPE CommentType;
DROP TYPE LikeType;
DROP TYPE PostType;
DROP TYPE RegularUserType;
DROP TYPE AdminType;
DROP TYPE UserType;


-- User object type with attributes common to all users
CREATE OR REPLACE TYPE UserType AS OBJECT (
    user_id NUMBER,
    username VARCHAR2(50),
    email VARCHAR2(100),
    password_hash VARCHAR2(255),
    created_at DATE
) NOT FINAL;

-- Admin object type inheriting from UserType
CREATE OR REPLACE TYPE AdminType UNDER UserType (
    admin_id NUMBER,
    reports_viewed NUMBER,
    last_login DATE,
    admin_level NUMBER
);

-- RegularUser object type inheriting from UserType
CREATE OR REPLACE TYPE RegularUserType UNDER UserType (
    profile_picture VARCHAR2(500),
    bio VARCHAR2(4000),
    user_status VARCHAR2(255),
    followers NUMBER,
    following NUMBER
);


-- Post object type
CREATE OR REPLACE TYPE PostType AS OBJECT (
    post_id NUMBER,
    content CLOB,
    created_at DATE,        
    user_ref REF UserType
);

-- Like object type
CREATE OR REPLACE TYPE LikeType AS OBJECT (
    like_id NUMBER,
    user_ref REF UserType,
    post_ref REF PostType,
    created_at DATE
);

-- Comment object type
CREATE OR REPLACE TYPE CommentType AS OBJECT (
    comment_id NUMBER,
    content CLOB,
    created_at DATE,
    user_ref REF UserType,
    post_ref REF PostType
);


-- Message object type for private communication
CREATE OR REPLACE TYPE MessageType AS OBJECT (
    message_id NUMBER,
    content CLOB,
    sent_at DATE,
    sender_ref REF UserType,
    receiver_ref REF UserType
);

-- Finished creating types for the database
