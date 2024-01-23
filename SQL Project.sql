-- loading 8 million rows of data
LOAD DATA INFILE 'C:/Climate.csv'
INTO TABLE climate
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Since data has rows for hourly data as well but blank, going to delete those since we only want daily data
DELETE FROM climate
WHERE DailyAverageDewPointTemperature = '';

-- Deleting columns that don't really mean anything or redundant
ALTER TABLE climate
DROP COLUMN STATION,
DROP COLUMN REPORT_TYPE, 
DROP COLUMN SOURCE,
DROP COLUMN BackupLatitude,
DROP COLUMN BackupLongitude,
DROP COLUMN DailyWeather,
DROP COLUMN DailyMinimumDryBulbTemperature,
DROP COLUMN DailyMaximumDryBulbTemperature,
DROP COLUMN DailyPeakWindDirection,
DROP COLUMN DailyPeakWindSpeed,
DROP COLUMN DailySustainedWindDirection,
DROP COLUMN DailySustainedWindSpeed;

-- Changing formatting of date to MM-DD-YYYY by taking on the left 10 characters
UPDATE climate
SET DATE = LEFT(DATE, 10);

-- Have the letter T in Daily Precipitation, which stands for Traces of rain, and according
-- to their website, it is about 0.005 inches of rain
UPDATE climate
SET DailyPrecipitation = REPLACE(DailyPrecipitation, 'T', '0.005')
WHERE DailyPrecipitation LIKE '%T%';

UPDATE climate
SET DailySnowFall = REPLACE(DailySnowFall, 'T', '0.05')
WHERE DailySnowFall LIKE '%T%';

UPDATE climate
SET DailySnowDepth = REPLACE(DailySnowDepth, 'T', '0.5')
WHERE DailySnowDepth LIKE '%T%';

ALTER TABLE climate
ADD COLUMN MONTH CHAR(2);

UPDATE climate
SET MONTH = SUBSTRING(DATE, 6, 2);

SELECT COUNT(*) FROM climate WHERE DailyPrecipitation IS NULL;


