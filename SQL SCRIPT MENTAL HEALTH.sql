CREATE DATABASE Mental_Health;
USE Mental_Health;

------ 1. Using the Select Query to retirieve the data from Table -------

SELECT * FROM mental;

------  2. Making a new table on which we can work on & inserting the values in it ---------

CREATE TABLE mental2
LIKE mental;

INSERT INTO mental2
SELECT * FROM mental;

-------- 3. The new table has been created but now we will retrieve data from it and start working on it--------

SELECT * FROM mental2;

--------- 4. Checking for any duplicates using the windows function and row_number()-----

SELECT*,
ROW_NUMBER() OVER (PARTITION BY `Patient ID`, Age, Gender, Diagnosis, `Symptom Severity (1-10)`,`Mood Score (1-10)`, `Physical Activity (hrs/week)`, Medication,
`Therapy Type`, `Treatment Start Date`,`Treatment Duration (weeks)`,`Stress Level (1-10)`, Outcome, `Treatment Progress (1-10)`,`AI-Detected Emotional State`, `Adherence to Treatment (%)`) as row_num
FROM mental2;

-------  4. Using a CTE to confirm if ther are any duplicates or not -------

WITH CTEmental AS (
SELECT*,
ROW_NUMBER() OVER (PARTITION BY `Patient ID`, Age, Gender, Diagnosis, `Symptom Severity (1-10)`,`Mood Score (1-10)`, `Physical Activity (hrs/week)`, Medication,
`Therapy Type`, `Treatment Start Date`,`Treatment Duration (weeks)`,`Stress Level (1-10)`, Outcome, `Treatment Progress (1-10)`,`AI-Detected Emotional State`, `Adherence to Treatment (%)`) as row_num
FROM mental2
)
SELECT * FROM CTEmental
WHERE row_num >1;

---- The data set does not have any duplicates and now we can proceed to further steps----


SELECT * FROM mental2;

-------------- 1. Demographic Insghts ---------------
---- A. Gender Distibution------


SELECT Gender, COUNT(*) AS TOTAL
FROM mental2
GROUP BY Gender;

-------- B. Age Distribution------

SELECT
	CASE
		When Age Between 10 and 19 THEN "10-19"
        WHEN Age Between 20 and 40 THEN "20-40"
        WHEN Age Between 41 AND 59 THEN "41-59"
        ELSE "60"
        END AS Age_group,
		COUNT(*) AS Age_Bracket
        FROM mental2
        GROUP BY Age_group;

--------------------------------------------------------
-------- c. Average age of patients --------
SELECT AVG(Age) As Average_Age
FROM mental2;

------ 2.Diagnosis and Treatment -------
----- a. Most Common Health Diagnosis----

SELECT Diagnosis, COUNT(*) AS Total_Diagnosis
FROM mental2
GROUP BY Diagnosis
ORDER BY  Total_Diagnosis DESC;
-------- b. Average Treatment Duration in weeks for diagnosis----


SELECT Diagnosis, AVG(`Treatment Duration (weeks)`) AS Treatment_TimeWEEK
FROM mental2
GROUP BY Diagnosis; 

------- c. Diagnosis associated with worst outcome------
SELECT * FROM mental2;

----- ------- 
------- d. Improvement shown by the patients ------

SELECT Outcome, Count(*) AS Total_Outcome
FROM mental2
GROUP BY  Outcome
ORDER BY  Outcome DESC;

------- 3. Sympotoms Severirty and treatment progress -----
---- a. what is the average sympotoms severity score for each diagnosis-----



SELECT Diagnosis, AVG(`Symptom Severity (1-10)`) AS AVG_Symptoms_Score
FROM mental2
GROUP BY  Diagnosis;

------ b. Is there any correlation between high symptoms and poor treatment ouctome-----

SELECT * FROM mental2;
SELECT Diagnosis,
	AVG(`Symptom Severity (1-10)`) AS AVG_SEVERITY,
    AVG(`Treatment Progress (1-10)`) AVG_PROGRESS
FROM mental2
GROUP BY Diagnosis;
---- This showed that there was correlation between Symptoms sevirity and treatment progress-----

---- d. What is the average treatment progress score across all patients-----

SELECT AVG(`Treatment Progress (1-10)`) AVG_Progress
FROM mental2;

----- e. what diagnosis have the highest treatment progress----

SELECT * FROM mental2;
SELECT Diagnosis, AVG(`Treatment Progress (1-10)`) HIGHEST_PROGRESS
FROM mental2
GROUP BY Diagnosis
ORDER BY Diagnosis DESC
LIMIT 1,5;

------- 4. MEdication and therapy insights------

----- a. Most commonly prescribed medications------

SELECT Medication, Count(*) AS TOTAL
FROM mental2
GROUP BY Medication 
ORDER BY TOTAL DESC;

------- b. Which Therapy types are used most frequntly -----

SELECT `Therapy Type`, COUNT(`Therapy Type`) AS TOP_THERAPIES
FROM mental2
GROUP BY `Therapy Type`
ORDER BY TOP_THERAPIES DESC;

------ c.  Most common outcome for therapy types-----

SELECT * FROM mental2;
SELECT `Therapy Type`, COUNT(Outcome) AS Therapy_outcome
FROM mental2
GROUP BY `Therapy Type`
ORDER BY Therapy_outcome DESC;

-------  d. How does the outcome vary of medication-----


SELECT Medication, COUNT(Outcome) Ouctomeby_Medication
FROM mental2
GROUP BY Medication
ORDER BY Ouctomeby_Medication DESC;

-------- 5. LIfe style and wellbieng analysis -------

------ a. Does higher physical activity correlate with better mood or sleep quality?------

SELECT 
	CASE 
    WHEN `Physical Activity (hrs/week)` <3 THEN "LOW PHYSICAL ACTIVITY"
    WHEN `Physical Activity (hrs/week)` BETWEEN 3 AND 6 THEN 'MODERATE PHYSCIAL ACTIVITY'
    ELSE "HIGH PHYSCIAL ACTIVITY"
    END AS ACTIVITY_LEVEL,
	ROUND(AVG(`Mood Score (1-10)`) ,1)AVG_MOOD,
    ROUND(AVG(`Sleep Quality (1-10)`),1) AVG_SLEEP
    FROM mental2
    GROUP BY ACTIVITY_LEVEL
    ORDER BY ACTIVITY_LEVEL ;


--------- b. Sleep Quality Affecting treatment outcome------

SELECT * FROM mental2;
SELECT Outcome, AVG(`Sleep Quality (1-10)`) AVG_SLEEP
FROM mental2
GROUP BY Outcome
ORDER BY AVG_SLEEP DESC
;

SELECT * FROM mental2;
------------ c. Do patients with higher physcial acitivity have higher treatment adherenece------

SELECT 
	CASE
    WHEN (`Physical Activity (hrs/week)`) <3 THEN "LOW PHYSCIAL ACTIVITY "
    WHEN (`Physical Activity (hrs/week)`) BETWEEN 3 AND 6 THEN "MODERATE PHYSICAL ACTIVITY"
    ELSE "HIGH PHYSCIAL ACTIVITY"
    END AS PHYSICAL_ACTIVITES,
    round(AVG(`Adherence to Treatment (%)`),1) AS Adeherenece
    FROM mental2
    GROUP BY PHYSICAL_ACTIVITES;

------- 6. Emotional state and Adherence---------

------- a. What are most common Ai detected emotional states----


SELECT `AI-Detected Emotional State`, COUNT(*) AS STATES_DETECTED
FROM mental2
GROUP BY `AI-Detected Emotional State`;
 
------- b. How does the emotional state vary acrros different diagnosis-------
SELECT * FROM mental2;

SELECT Diagnosis, `AI-Detected Emotional State`, COUNT(`AI-Detected Emotional State`) AS DETECTED
FROM mental2
GROUP BY Diagnosis, `AI-Detected Emotional State`
ORDER BY  Diagnosis;

-------- c.What is the average adherence to treatment (%) by outcome category?----

SELECT * FROM mental2;

SELECT OUTCOME,
	ROUND(AVG(`Adherence to Treatment (%)`),1) AS Treatment_Adherenece
    FROM mental2
    GROUP BY Outcome;
    
------- d. Relation between emotional state and treamtnet progress ----- 

SELECT * FROM mental2;
SELECT `AI-Detected Emotional State`,ROUND(AVG (`Treatment Progress (1-10)`),2 )AS Treatment_progress
FROM mental2
GROUP BY `AI-Detected Emotional State`
ORDER BY `Treatment_progress` DESC;

---------- ------------
SELECT * FROM mental;


------- Using my sql we unvield the Trends and insights from this data.------
------- Through this trend the hospital will be able to know how to handle the pateints-----
----- Hospitals can know what mental state was the most worse and how was it handled-----
------  By studying the insights better decisions can be taken for the future. Medicinec and treatment can be enhanced-------