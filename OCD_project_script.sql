-- Check for Null values --
SELECT *
FROM ocd_patient_dataset
WHERE `Patient ID` IS NULL
   OR `Age` IS NULL
   OR `Gender` IS NULL
   OR `Ethnicity` IS NULL
   OR `Marital Status` IS NULL
   OR `Education Level` IS NULL
   OR `OCD Diagnosis Date` IS NULL
   OR `Duration of Symptoms (months)` IS NULL
   OR `Previous Diagnoses` IS NULL
   OR `Family History of OCD` IS NULL
   OR `Obsession Type` IS NULL
   OR `Compulsion Type` IS NULL
   OR `Y-BOCS Score (Obsessions)` IS NULL
   OR `Y-BOCS Score (Compulsions)` IS NULL
   OR `Depression Diagnosis` IS NULL
   OR `Anxiety Diagnosis` IS NULL
   OR `Medications` IS NULL;
   
-- Check for Duplicates --
SELECT
    `Patient ID`,
    `Age`,
    `Gender`,
    `Ethnicity`,
    `Marital Status`,
    `Education Level`,
    `OCD Diagnosis Date`,
    `Duration of Symptoms (months)`,
    `Previous Diagnoses`,
    `Family History of OCD`,
    `Obsession Type`,
    `Compulsion Type`,
    `Y-BOCS Score (Obsessions)`,
    `Y-BOCS Score (Compulsions)`,
    `Depression Diagnosis`,
    `Anxiety Diagnosis`,
    `Medications`,
    COUNT(*) AS DuplicateCount
FROM ocd_patient_dataset
GROUP BY
    `Patient ID`,
    `Age`,
    `Gender`,
    `Ethnicity`,
    `Marital Status`,
    `Education Level`,
    `OCD Diagnosis Date`,
    `Duration of Symptoms (months)`,
    `Previous Diagnoses`,
    `Family History of OCD`,
    `Obsession Type`,
    `Compulsion Type`,
    `Y-BOCS Score (Obsessions)`,
    `Y-BOCS Score (Compulsions)`,
    `Depression Diagnosis`,
    `Anxiety Diagnosis`,
    `Medications`
HAVING COUNT(*) > 1;

-- 1. Count & Percent of Male vs Female that have OCD & Average Obsession Score by Gender --
with data as (
SELECT
Gender,
count(`Patient ID`) as patient_count,
round(avg(`Y-BOCS Score (Obsessions)`),2) as avg_obs_score

FROM ocd_patient_dataset
Group By 1
Order by 2
)
select
	sum(case when Gender = 'Female' then patient_count else 0 end) as count_female,
	sum(case when Gender = 'Male' then patient_count else 0 end) as count_male,

	round(sum(case when Gender = 'Female' then patient_count else 0 end)/
	(sum(case when Gender = 'Female' then patient_count else 0 end)+sum(case when Gender = 'Male' then patient_count else 0 end)) *100,2)
	 as pct_female,

    round(sum(case when Gender = 'Male' then patient_count else 0 end)/
	(sum(case when Gender = 'Female' then patient_count else 0 end)+sum(case when Gender = 'Male' then patient_count else 0 end)) *100,2)
	 as pct_male
from data;

-- 2. Count of Patients by Ethnicity and their respective Average Obsession Score -- 
select
	Ethnicity,
	count(`Patient ID`) as patient_count,
	avg(`Y-BOCS Score (Obsessions)`) as obs_score
From ocd_patient_dataset
Group by 1
Order by 2;

-- 3. Number of people diagnosed with OCD Month over Month --
-- alter table ocd_patient_dataset
-- modify `OCD Diagnosis Date` date;
select
date_format(`OCD Diagnosis Date`, '%Y-%m-01 00:00:00') as month,
-- `OCD Diagnosis Date`
count(`Patient ID`) patient_count
from ocd_patient_dataset
group by 1
Order by 1;

-- 4. What is the most common Obsession Type (Count) & it's respective Average Obsession Score --
Select
`Obsession Type`,
count(`Patient ID`) as patient_count,
round(avg(`Y-BOCS Score (Obsessions)`),2) as obs_score
from ocd_patient_dataset
group by 1
Order by 2;

-- 5. What is the most common Compulsion type (Count) & it's respective Average Obsession Scoreocd_patient_dataset --
Select
`Compulsion Type`,
count(`Patient ID`) as patient_count,
round(avg(`Y-BOCS Score (Obsessions)`),2) as obs_score
from ocd_patient_dataset
group by 1
Order by 2;