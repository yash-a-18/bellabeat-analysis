-- Finding the NULL values
SELECT * FROM bellabeat.dailyactivity_merged;

-- Find the zero/null counts for each column
-- Showing the total counts for the same
-- CASE WHEN ... THEN ... ELSE ... END: This is a conditional expression that allows you to perform different actions based on specified conditions.
-- WHEN columnX = 0: This part checks if the value in the columnX is equal to 0.
-- THEN 1: If the condition is true, it returns 1, indicating that the column contains a zero value.
-- ELSE 0: If the condition is false, it returns 0.
SELECT 
	SUM(CASE WHEN ActivityDate = 0 THEN 1 ELSE 0 END) AS null_ActivityDate,
	SUM(CASE WHEN TotalSteps = 0 THEN 1 ELSE 0 END) AS null_TotalSteps,
    SUM(CASE WHEN TotalDistance = 0 THEN 1 ELSE 0 END) AS null_TotalDistance,
	SUM(CASE WHEN TrackerDistance = 0 THEN 1 ELSE 0 END) AS null_TrackerDistance,
	SUM(CASE WHEN LoggedActivitiesDistance = 0 THEN 1 ELSE 0 END) AS null_LoggedActivitiesDistance,
    SUM(CASE WHEN VeryActiveDistance = 0 THEN 1 ELSE 0 END) AS null_VeryActiveDistance,
    SUM(CASE WHEN ModeratelyActiveDistance = 0 THEN 1 ELSE 0 END) AS null_ModeratelyActiveDistance,
    SUM(CASE WHEN LightActiveDistance = 0 THEN 1 ELSE 0 END) AS null_LightActiveDistance,
    SUM(CASE WHEN SedentaryActiveDistance = 0 THEN 1 ELSE 0 END) AS null_SedentaryActiveDistance,
    SUM(CASE WHEN VeryActiveMinutes = 0 THEN 1 ELSE 0 END) AS null_VeryActiveMinutes,
    SUM(CASE WHEN FairlyActiveMinutes = 0 THEN 1 ELSE 0 END) AS null_FairlyActiveMinutes,
    SUM(CASE WHEN LightlyActiveMinutes = 0 THEN 1 ELSE 0 END) AS null_LightlyActiveMinutes,
    SUM(CASE WHEN SedentaryMinutes = 0 THEN 1 ELSE 0 END) AS null_SedentaryMinutes,
    SUM(CASE WHEN Calories = 0 THEN 1 ELSE 0 END) AS null_Calories
FROM bellabeat.dailyactivity_merged;

-- The TotalSteps is zero can be due the error occurred during the manual entry or forgetting to wear the watch/device
-- Showing the total counts for the same
SELECT COUNT(*) AS Null_TotalSteps FROM bellabeat.dailyactivity_merged 
WHERE TotalSteps = '0';


-- Turning safe updates off because we are not going to use the primary key to delete the rows
-- If we use primary key to delete the rows then we do not need to do this
SET SQL_SAFE_UPDATES = 0;

-- Deleting those rows
-- Always exercise caution when using the DELETE statement, especially in a production database, as it permanently removes data.
-- It's a good practice to create backups or use transactions to ensure you can recover data if needed.
DELETE FROM bellabeat.dailyactivity_merged
WHERE TotalSteps = '0';

-- Turning safe updates ON again to avoid unnecessary changes
SET SQL_SAFE_UPDATES = 1;

-- Showing the total counts for TotalSteps = 0, it should return 0
SELECT COUNT(*) AS Null_TotalSteps
FROM bellabeat.dailyactivity_merged 
WHERE TotalSteps = '0';

-- Finding number of Unique/Distinct users
SELECT COUNT(DISTINCT Id) AS DistinctUsers
FROM bellabeat.dailyactivity_merged;

SELECT * FROM bellabeat.sleepday_merged;

-- Finding all NULL values in sleepday_merged
SELECT
	SUM(CASE WHEN SleepDay = 0 THEN 1 ELSE 0 END) AS null_SleepDay,
    SUM(CASE WHEN TotalSleepRecords = 0 THEN 1 ELSE 0 END) AS null_TotalSleepRecords,
    SUM(CASE WHEN TotalMinutesAsleep = 0 THEN 1 ELSE 0 END) AS null_TotalMinutesAsleep,
    SUM(CASE WHEN TotalTimeInBed = 0 THEN 1 ELSE 0 END) AS null_TotalTimeInBed
FROM bellabeat.sleepday_merged;

-- Finding the number of Unique/Distinct users in SleepDay
SELECT COUNT(DISTINCT Id) as UniqueUsers
FROM bellabeat.sleepday_merged;

-- Finding common Users in dailyactivity and sleepday
SELECT COUNT(DISTINCT da.Id) AS CommonUsers
FROM bellabeat.dailyactivity_merged as da, bellabeat.sleepday_merged as sd
WHERE da.Id = sd.Id;

-- The data type of ActivityDate is text
-- Showing it in required Data format
SELECT DATE_FORMAT(STR_TO_DATE(ActivityDate, '%m/%d/%Y'), '%Y-%m-%d') AS new_date_format
FROM bellabeat.dailyactivity_merged;

-- Using a temporary column for making changes or using it as a reference column
ALTER TABLE bellabeat.dailyactivity_merged
ADD temp_date_column DATE;

SET SQL_SAFE_UPDATES = 0;
UPDATE bellabeat.dailyactivity_merged
SET temp_date_column = DATE_FORMAT(STR_TO_DATE(ActivityDate, '%m/%d/%Y'), '%Y-%m-%d');

-- Updating the actual column 
UPDATE bellabeat.dailyactivity_merged
SET ActivityDate = DATE_FORMAT(temp_date_column, '%Y-%m-%d');
SET SQL_SAFE_UPDATES = 1;

-- Droping the temporary column
ALTER TABLE bellabeat.dailyactivity_merged
DROP COLUMN temp_date_column;

-- Adding a column for the day of week
Alter Table bellabeat.dailyactivity_merged
ADD day_of_week nvarchar(50);

SET SQL_SAFE_UPDATES = 0;
-- Finding the day of the week and assigning it to the column
Update bellabeat.dailyactivity_merged
SET day_of_week = DATE_FORMAT(ActivityDate, '%W');
SET SQL_SAFE_UPDATES = 1;