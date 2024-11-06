 SELECT *  FROM Portfolio_database..annualdeaths; 

 -- first analyzing the data of 1st class country like USA
SELECT * FROM Portfolio_database..annualdeaths Where Entity = 'United States'
order by Year;
 
 --Truncate table dideaths_usa;

--Filtering Data for the analysis and saving it to the new table non-disease numbers
SELECT Year, Nutritional_deficiencies, Interpersonal_violence, Drug_use, Self_harm, Exposure_to_forces_of_nature, Environmentalheat_and_coldexposure, Conflict_and_terrorism, Poisonings, Protein_energy_malnutrition, Terrorism_deaths, Road_injuries, Fireheatandhot
INTO deaths_usa FROM Portfolio_database..annualdeaths Where Entity = 'United States';



--Filtering Data for the analysis and saving it to the new table disease numbers
SELECT Year,  Meningitis, Alzheimer_dementias, Parkinson, Malaria, Maternal_disorders, HIV_AIDS, Tuberculosis, Lower_respiratory_infections, Neonatal_disorders, Diarrheal_diseases, Neoplasms, Diabetes_mellitus, Chronic_kidney_disease, Chronic_respiratory_diseases, Cirrhosis_chronic_liver_diseases, Digestive_diseases, Acute_hepatitis 
INTO dideaths_usa FROM Portfolio_database..annualdeaths Where Entity = 'United States';

select * from deaths_usa;
select * from dideaths_usa;


-- Adding new columns Total in the table 
--ALTER TABLE dbo.deaths_usa
--ADD Total int;

-- Adding new columns Total in the table 
--ALTER TABLE dbo.dideaths_usa
--ADD Total int;

-- Adding data by years
SELECT Year, (  Meningitis + Alzheimer_dementias + Parkinson + Malaria + Maternal_disorders + HIV_AIDS + Tuberculosis + Lower_respiratory_infections + Neonatal_disorders + Diarrheal_diseases + Neoplasms + Diabetes_mellitus + Chronic_kidney_disease + Chronic_respiratory_diseases + Cirrhosis_chronic_liver_diseases + Digestive_diseases + Acute_hepatitis)
as Total_dideath From dideaths_usa;

SELECT Year, (  Nutritional_deficiencies + Interpersonal_violence + Drug_use + Self_harm + Exposure_to_forces_of_nature + Environmentalheat_and_coldexposure + Conflict_and_terrorism + Poisonings + Protein_energy_malnutrition + Terrorism_deaths + Road_injuries + Fireheatandhot)
as Total_death From deaths_usa;


--finding the unique values from the table annual death
-- SELECT distinct Entity FROM Portfolio_database..annualdeaths;

-- Now outer joinging the two tables deaths_usa and dideaths_usa 
SELECT Total_death
FROM deaths_usa
LEFT JOIN dideaths_usa
ON deaths_USA.Year= dideaths_usa.Year;



-- viewing the total deaths

---Viewing by percentage

-- Viewing total by country

