



/* Create table businesses with the given attributes */
CREATE TABLE businesses (
    BusinessID VARCHAR(22) primary key,
    Business_Name VARCHAR(225),
    Street_Address VARCHAR(225),
    City VARCHAR(225),
    State CHAR(3),
    Postal_Code CHAR(9),
    Latitude DECIMAL(9, 7),
    Longitude DECIMAL(10, 7),
    Average_Reviews DECIMAL(3, 1),
    Number_Of_Reviews INT,
    Is_Business_Open INTEGER,
    CONSTRAINT Average_Reviews CHECK (Average_Reviews >= 0.0 AND Average_Reviews <= 5.0),
    CONSTRAINT Is_Business_Open CHECK (Is_Business_Open = ANY (ARRAY[0, 1]))
);
\COPY businesses FROM '/Users/sairamreddy/Desktop/MSDA/Semester -1/DMIT/Final Project/OneDrive_1_11-26-2023/businesses.csv' DELIMITER ',' CSV 

/* Create table businesscategories with business_id as foreign key*/

CREATE TABLE businesscategories(
    BusinessID VARCHAR(22),
    Category_Name VARCHAR(260), 
    FOREIGN KEY (BusinessID) REFERENCES businesses(BusinessID)

);
\COPY Businesscategories FROM '/Users/sairamreddy/Desktop/MSDA/Semester -1/DMIT/Final Project/OneDrive_1_11-26-2023/business_categories.csv' DELIMITER ',' CSV;

/*Create table businessattributes with business_id as foreign key*/
CREATE TABLE businessattributes (
    BusinessID VARCHAR(22),
    Attribute_Name VARCHAR(260), 
    Attribute_Value VARCHAR(260), 
    FOREIGN KEY (BusinessID) REFERENCES businesses(BusinessID)
);

\COPY businessattributes FROM '/Users/sairamreddy/Desktop/MSDA/Semester -1/DMIT/Final Project/OneDrive_1_11-26-2023/business_attributes.csv' DELIMITER ',' CSV;

/*Create table Businesshours with with business_id as foreign key*/
CREATE TABLE businesshours (
    BusinessID VARCHAR(22),
    Day_of_week VARCHAR(50), 
    Opening_Time TIME WITHOUT TIME ZONE,
    Closing_Time TIME WITHOUT TIME ZONE,
    FOREIGN KEY (BusinessID) REFERENCES businesses(BusinessID)
);

\COPY businesshours FROM '/Users/sairamreddy/Desktop/MSDA/Semester -1/DMIT/Final Project/OneDrive_1_11-26-2023/business_hours.csv' DELIMITER ',' CSV;

/*Create table users_DETAILS with user_id as primary key */
CREATE TABLE userDetails (
    UserID VARCHAR(22) PRIMARY KEY,
    Name VARCHAR(260),
    Num_Reviews_left INTEGER,
    Join_Date TIMESTAMP WITHOUT TIME ZONE,
    Useful_Votes_sent INTEGER,
    Funny_Votes_sent INTEGER,
    Cool_Votes_sent INTEGER,
    Num_Fans INTEGER,
    Avg_Rating NUMERIC(3, 2),
    Hot_Compliments_received INTEGER,
    More_Compliments_received INTEGER,
    Profile_Compliments_received INTEGER,
    Cute_Compliments_received INTEGER,
    List_Compliments_received INTEGER,
    Note_Compliments_received INTEGER,
    Plain_Compliments_received INTEGER,
    Cool_Compliments_received INTEGER,
    Funny_Compliments_received INTEGER,
    Writer_Compliments_received INTEGER,
    Photo_Compliments_received INTEGER,
    CONSTRAINT Avg_Rating CHECK (Avg_Rating >= 0.0 AND Avg_Rating <= 5.0)
);

\COPY userDetails  FROM ‘/Users/sairamreddy/Desktop/MSDA/Semester -1/DMIT/Final Project/users/users_part0.csv' DELIMITER ',' CSV

/*Create table reviews */

CREATE TABLE reviews (
    ReviewID VARCHAR(22) PRIMARY KEY,
    UserID VARCHAR(22),
    BusinessID VARCHAR(22),
    User_Rating NUMERIC(3, 1),
    Useful_Count INTEGER,
    Funny_Count INTEGER,
    Cool_Count INTEGER,
    Review_Text TEXT,
    Review_Datetime TIMESTAMP WITHOUT TIME ZONE,
    FOREIGN KEY (BusinessID) REFERENCES BUSINESSES(BusinessID),
    CONSTRAINT User_Rating CHECK (User_Rating >= 0.0 AND User_Rating <= 5.0)
);
\COPY reviews FROM '/Users/sairamreddy/Desktop/MSDA/Semester -1/DMIT/Final Project/business_reviews/business_reviews_part0.csv' DELIMITER ',' CSV;

/*Create table tips with user_id as primary key and business_id as foreign key*/ 
CREATE TABLE tips (
    UserID VARCHAR(22),
    BusinessID VARCHAR(22),
    Tip_Text TEXT,
    Tip_Datetime TIMESTAMP WITHOUT TIME ZONE,
    Num_Compliments INTEGER,
    FOREIGN KEY (BusinessID) REFERENCES BUSINESSES(BusinessID),
    FOREIGN KEY (UserID) REFERENCES userDetails(UserID)
);
\COPY tips FROM '/Users/sairamreddy/Desktop/MSDA/Semester -1/DMIT/Final Project/OneDrive_1_11-26-2023/tips.csv' DELIMITER ',' CSV;
/*Create table usereliteyears with user_id */

create table usereliteyears (
    UserID VARCHAR(22),
    Year Integer,
    FOREIGN KEY (UserID) REFERENCES userDetails(UserID)

    );

\COPY usereliteyears FROM '/Users/sairamreddy/Desktop/MSDA/Semester -1/DMIT/Final Project/OneDrive_1_11-26-2023/user_elite_years.csv' DELIMITER ',' CSV;























