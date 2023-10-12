
--Pull up entire dataset
Select * from dbo.hospital_ER


--Average Patient Age By Gender

SELECT patient_gender, AVG(patient_age) AS avg_age
FROM dbo.Hospital_ER
GROUP BY patient_gender;

--Average Patient Waititme by Department 

SELECT department_referral, AVG(patient_waittime) AS avg_wait_time
FROM dbo.hospital_ER
GROUP BY department_referral;

--Percentage of Patients with Admin Flag

SELECT patient_admin_flag, COUNT(*) AS count
FROM dbo.hospital_ER
GROUP BY patient_admin_flag;


--Top Referral Departments

SELECT Top 5 department_referral, COUNT(*) AS referral_count
FROM dbo.hospital_ER
GROUP BY department_referral
ORDER BY referral_count DESC;

--Patient Satisfaction Score Distribution

SELECT patient_sat_score, COUNT(*) AS count
FROM dbo.hospital_ER
GROUP BY patient_sat_score
ORDER BY patient_sat_score;


--Average Age of Patients by Race

SELECT patient_race, AVG(patient_age) AS avg_age
FROM dbo.hospital_ER
GROUP BY patient_race;


--Patients with High Satisfaction Score by Gender

SELECT patient_gender, COUNT(*) AS count
FROM dbo.hospital_ER
WHERE patient_sat_score >= 8
GROUP BY patient_gender;


--Average Patient Age and Wait Time for Admin Flagged Patients

SELECT patient_admin_flag, AVG(patient_age) AS avg_age, AVG(patient_waittime) AS avg_wait_time
FROM dbo.hospital_ER
GROUP BY patient_admin_flag;


--Average Wait time over time

SELECT FORMAT(date, 'yyyy-MM') AS month, AVG(patient_waittime) AS avg_wait_time
FROM dbo.hospital_ER
GROUP BY FORMAT(date, 'yyyy-MM');



--Patient Count by Age Group

SELECT
  CASE
    WHEN patient_age < 18 THEN 'Under 18'
    WHEN patient_age >= 18 AND patient_age < 65 THEN '18-64'
    ELSE '65 and older'
  END AS age_group,
  COUNT(*) AS count
FROM dbo.hospital_ER
GROUP BY patient_age;


--Patiients over Age 50

SELECT patient_id, patient_age, patient_sat_score
FROM dbo.hospital_ER
WHERE patient_age >= 50
ORDER BY patient_age DESC;


--Count of Patients by Race

SELECT patient_race, COUNT(*) AS race_count
FROM dbo.hospital_ER
GROUP BY patient_race;


--Maximum and Minimum Patient Age
SELECT MAX(patient_age) AS max_age, MIN(patient_age) AS min_age
FROM dbo.hospital_ER;


-- Sum of Wait time for Admin_Flagge Patients

SELECT patient_admin_flag, SUM(patient_waittime) AS total_wait_time
FROM dbo.hospital_ER
GROUP BY patient_admin_flag;


--Patients with Longest Wait time

SELECT *
FROM dbo.hospital_ER
WHERE patient_waittime = (SELECT MAX(patient_waittime) FROM dbo.hospital_ER);


--Patient Satisfaction Score Categories

SELECT
  patient_id,
  patient_sat_score,
  CASE
    WHEN patient_sat_score >= 8 THEN 'High'
    WHEN patient_sat_score >= 6 THEN 'Medium'
    ELSE 'Low'
  END AS satisfaction_category
FROM dbo.hospital_ER;


--Filtering Department Average Wait time >30

SELECT department_referral, AVG(patient_waittime) AS avg_wait_time
FROM dbo.hospital_ER
GROUP BY department_referral
HAVING AVG(patient_waittime) > 30;


