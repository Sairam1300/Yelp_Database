/*How many users have joined Yelp each year since 2010?*/

select extract(Year from Join_Date) as Join_Year, count(*) as User_Count 
from userDetails where extract(Year from Join_Date) >= 2010 
group by Join_Year order by Join_Year;

/* How many users were elite in each of the 10 years from 2012 through 2021? Does it look like the number of elite users is increasing, decreasing, or staying about the same?*/

select Year,count(*) as elite_user_count 
from usereliteyears where year between 2012 and 2021 
group by Year order by Year;

/*Which of our users has the most 5-star reviews of all time? Give us the person’s name, when they joined Yelp, how many fans they have, how many funny, useful, and cool ratings they’ve gotten. Please also gives us 3-5 examples of recent 5-star reviews they have written.*/

SELECT 
    ud.Name, ud.Join_Date, ud.Num_Fans,
	COUNT(CASE WHEN r.User_Rating = 5 THEN 1 END) AS num_of_5_star_reviews,
    SUM(r.Useful_Count) AS useful_count,
  	SUM(r.Funny_Count) AS funny_count,
  	SUM(r.Cool_Count ) AS cool_count,
    STRING_AGG(r.Review_Text, '; ') 
	FROM userDetails ud join reviews r on ud.UserID = r.UserID
	GROUP BY ud.Name, ud.Join_Date, ud.Num_Fans
	ORDER BY num_of_5_star_reviews DESC LIMIT 5;

/*We’d like to talk with users who have lots of friends on Yelp to better understand how they use the social features of our site. Can you give us user id and name of the 10 users with the most friends?*/

/* As we do not havd friends data we are unable to get the solution */

/*Which US states have the most businesses in our database? Give us the top 10 states.*/

SELECT State, COUNT(*) AS Number_Of_Businesses FROM businesses 
GROUP BY State ORDER BY Number_Of_Businesses DESC LIMIT 10;

/*What are our top ten business categories? In other words, which 10 categories have the most businesses assigned to them?*/

SELECT Category_Name, COUNT(*) AS Number_of_businesses FROM businesscategories 
GROUP BY Category_name 
ORDER BY Number_of_businesses DESC LIMIT 10;

/*What is the average rating of the businesses in each of those top ten categories?*/

SELECT Category_Name,COUNT(*) as Businesses_Count, avg(Average_Reviews) as average 
FROM businesscategories bc join businesses b on bc.BusinessID = b.BusinessID 
GROUP BY Category_Name 
ORDER BY Businesses_Count DESC LIMIT 10;

/*We’re wondering what makes users tag a Restaurant review as “funny”. Can you give us 5 examples of the funniest Restaurant reviews and 5 examples of the 10 least funny? We’d also like you to look at a larger set of funny and unfunny reviews and tell us if you see any patterns that separate the two. (We know the last part is qualitative, but tell us anything you see that may be useful.)*/

--------------leastfunny------------
with restaurants as (select BusinessID from businesscategories where Category_Name='Restaurants')
select Funny_Count,Review_text from reviews where BusinessID in (select BusinessID from restaurants) order by Funny_Count limit 20;
---------------mostfunny-------------
with restaurants as (select BusinessID from businesscategories where Category_Name='Restaurants')
select Funny_Count,Review_Text from reviews where BusinessID in (select BusinessID from restaurants) order by Funny_Count desc limit 20;

/* We think the compliments that tips receive are mostly based on how long the tip is. Can you compare the average length of the tip text for the 100 most-complimented tips with the average length of the 100 least-complimented tips and tell us if that seems to be true? (Hint: you will need to use computed properties to answer this question).*/

SELECT (SELECT AVG(LENGTH(Tip_Text)) 
	FROM (SELECT Tip_Text FROM tips ORDER BY Num_Compliments DESC LIMIT 100) AS most_complimented) 
	AS avg_length_most_complimented,(SELECT AVG(LENGTH(Tip_Text)) 
	FROM (SELECT Tip_Text FROM tips WHERE Num_Compliments > 0 
		ORDER BY Num_compliments ASC, Tip_Datetime DESC LIMIT 100) AS least_complimented) AS avg_length_least_complimented;

/* We are trying to figure out whether restaurant reviews are driven mostly by price range, how many hours the restaurant is open, or the days they are open. Can you please give us a spreadsheet with the data we need to answer that question? (Note from Professor Augustyn: You don’t actually have to hand in a spreadsheet…just give me a table with 10 rows of sample data returned by your query.)*/


SELECT 
    BusinessID, Category_Name, Hours_Open,Average_Rating, Total_Useful_count, Total_Funny_count, Total_Cool_count, Reviews
FROM (
    SELECT 
        r.BusinessID, 
        bc.Category_Name, 
        SUM(EXTRACT(EPOCH FROM (bh.Closing_Time - bh.Opening_Time))/3600) AS Hours_Open,
        AVG(r.User_Rating) AS Average_Rating, 
        SUM(r.Useful_Count) AS Total_Useful_count, 
        SUM(r.Funny_Count) AS Total_Funny_count, 
        SUM(r.Cool_Count) AS Total_Cool_count, 
        ARRAY_AGG(r.Review_Text) AS Reviews,
        MAX(r.Review_Datetime) AS Max_Review_datetime
    FROM 
        reviews r 
    JOIN 
        businesscategories bc ON r.BusinessID = bc.BusinessID
    JOIN 
        businesshours bh ON bc.BusinessID = bh.BusinessID
    WHERE 
        bc.Category_Name = 'Restaurants' 
    GROUP BY 
        r.BusinessID, bc.Category_Name
) AS subquery
WHERE 
    Hours_Open > 0
ORDER BY 
    Average_Rating DESC, Max_Review_datetime DESC 
LIMIT 10;
