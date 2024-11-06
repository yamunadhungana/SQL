
-- using the non disease for the analysis
Select * from Portfolio_database..annualdeaths;


--Converting null to zero
UPDATE Portfolio_database..annualdeaths SET Nutritional_deficiencies=0 WHERE Nutritional_deficiencies IS NULL;
UPDATE Portfolio_database..annualdeaths SET Interpersonal_violence=0 WHERE Interpersonal_violence IS NULL;
UPDATE Portfolio_database..annualdeaths SET Drug_use=0 WHERE Drug_use IS NULL;
UPDATE Portfolio_database..annualdeaths SET Self_harm=0 WHERE Self_harm IS NULL;
UPDATE Portfolio_database..annualdeaths SET Exposure_to_forces_of_nature=0 WHERE Exposure_to_forces_of_nature IS NULL;
UPDATE Portfolio_database..annualdeaths SET Environmentalheat_and_coldexposure=0 WHERE Environmentalheat_and_coldexposure IS NULL;
UPDATE Portfolio_database..annualdeaths SET Conflict_and_terrorism=0 WHERE Conflict_and_terrorism IS NULL;
UPDATE Portfolio_database..annualdeaths SET Poisonings=0 WHERE Poisonings IS NULL;
UPDATE Portfolio_database..annualdeaths SET Protein_energy_malnutrition=0 WHERE Protein_energy_malnutrition IS NULL;
UPDATE Portfolio_database..annualdeaths SET Terrorism_deaths=0 WHERE Terrorism_deaths IS NULL;
UPDATE Portfolio_database..annualdeaths SET Road_injuries=0 WHERE Road_injuries IS NULL;
UPDATE Portfolio_database..annualdeaths SET Fireheatandhot=0 WHERE Fireheatandhot IS NULL;
UPDATE Portfolio_database..annualdeaths SET Meningitis=0 WHERE Meningitis IS NULL;
UPDATE Portfolio_database..annualdeaths SET Alzheimer_dementias=0 WHERE Alzheimer_dementias IS NULL;
UPDATE Portfolio_database..annualdeaths SET Parkinson=0 WHERE Parkinson IS NULL;
UPDATE Portfolio_database..annualdeaths SET Malaria=0 WHERE Malaria IS NULL;
UPDATE Portfolio_database..annualdeaths SET Maternal_disorders=0 WHERE Maternal_disorders IS NULL;
UPDATE Portfolio_database..annualdeaths SET HIV_AIDS=0 WHERE HIV_AIDS IS NULL;
UPDATE Portfolio_database..annualdeaths SET Tuberculosis=0 WHERE Tuberculosis IS NULL;
UPDATE Portfolio_database..annualdeaths SET Lower_respiratory_infections=0 WHERE Lower_respiratory_infections IS NULL;
UPDATE Portfolio_database..annualdeaths SET Neonatal_disorders=0 WHERE Neonatal_disorders IS NULL;
UPDATE Portfolio_database..annualdeaths SET Diarrheal_diseases=0 WHERE Diarrheal_diseases IS NULL;
UPDATE Portfolio_database..annualdeaths SET Neoplasms=0 WHERE Neoplasms IS NULL;
UPDATE Portfolio_database..annualdeaths SET Diabetes_mellitus=0 WHERE Diabetes_mellitus IS NULL;
UPDATE Portfolio_database..annualdeaths SET Chronic_kidney_disease=0 WHERE Chronic_kidney_disease IS NULL;
UPDATE Portfolio_database..annualdeaths SET Chronic_respiratory_diseases=0 WHERE Chronic_respiratory_diseases IS NULL;
UPDATE Portfolio_database..annualdeaths SET Cirrhosis_chronic_liver_diseases=0 WHERE Cirrhosis_chronic_liver_diseases IS NULL;
UPDATE Portfolio_database..annualdeaths SET Digestive_diseases=0 WHERE Digestive_diseases IS NULL;
UPDATE Portfolio_database..annualdeaths SET Acute_hepatitis=0 WHERE Acute_hepatitis IS NULL;



-- filtering the data for the further analysis
SELECT Year,Entity,Nutritional_deficiencies, Interpersonal_violence, Drug_use, Self_harm, Exposure_to_forces_of_nature, Environmentalheat_and_coldexposure, Conflict_and_terrorism, Poisonings, Protein_energy_malnutrition, Terrorism_deaths, Road_injuries, Fireheatandhot,
 Meningitis, Alzheimer_dementias, Parkinson, Malaria, Maternal_disorders, HIV_AIDS, Tuberculosis, Lower_respiratory_infections, Neonatal_disorders, Diarrheal_diseases, Neoplasms, Diabetes_mellitus, Chronic_kidney_disease, Chronic_respiratory_diseases, Cirrhosis_chronic_liver_diseases, Digestive_diseases, Acute_hepatitis,
(Meningitis + Alzheimer_dementias + Parkinson + Malaria + Maternal_disorders + HIV_AIDS + Tuberculosis + Lower_respiratory_infections + Neonatal_disorders + Diarrheal_diseases + Neoplasms + Diabetes_mellitus + Chronic_kidney_disease + Chronic_respiratory_diseases + Cirrhosis_chronic_liver_diseases + Digestive_diseases + Acute_hepatitis)
as totaldeath_bydisease, 
(Nutritional_deficiencies + Interpersonal_violence + Drug_use + Self_harm + Exposure_to_forces_of_nature + Environmentalheat_and_coldexposure + Conflict_and_terrorism + Poisonings + Protein_energy_malnutrition + Terrorism_deaths + Road_injuries + Fireheatandhot)
as totaldeath_bynondisease INTO mytable
FROM Portfolio_database..annualdeaths  order by Entity, Year;

select * from mytable


/* Viewing the death by the percentage
select Year, Entity, totaldeath_bydisease, totaldeath_bynondisease, (totaldeath_bydisease + totaldeath_bynondisease) as Total_death,
((totaldeath_bydisease*100)/(totaldeath_bydisease + totaldeath_bynondisease)) as per_bydisease, ((totaldeath_bynondisease*100)/(totaldeath_bydisease + totaldeath_bynondisease)) as per_bynondisease
FROM dbo.mytable order by Entity, Year; */


/*Select Year, Entity, totaldeath_bydisease, totaldeath_bynondisease, (totaldeath_bydisease*100)/(totaldeath_bydisease + totaldeath_bynondisease) as disease_percent, 
(totaldeath_bydisease*100)/(totaldeath_bydisease + totaldeath_bynondisease) as disease_percent */

SELECT Year, Entity, totaldeath_bydisease, totaldeath_bynondisease, (cast(totaldeath_bydisease + totaldeath_bynondisease as bigint)) as Total_death  into all_percentable  from mytable
order by Year, Entity;

SELECT Year, Entity, totaldeath_bydisease, totaldeath_bynondisease, Total_death FROM all_percentable where Total_death != 0
order by Entity, Year;




SELECT Year, Entity, totaldeath_bydisease, totaldeath_bynondisease, Total_death, ((cast(totaldeath_bydisease as numeric)* 100)/Total_death) as perbydisease, 
((cast(totaldeath_bynondisease as numeric)* 100)/Total_death) as perbynondisease into newpercentable from all_percentable 
where Total_death !=0
order by Entity, Year;


select * from newpercentable

-- joining the table mytable and newpercentable

SELECT mytable.Year, mytable.Entity, Nutritional_deficiencies, Interpersonal_violence, Drug_use, Self_harm, Exposure_to_forces_of_nature, Environmentalheat_and_coldexposure, Conflict_and_terrorism, Poisonings, Protein_energy_malnutrition, Terrorism_deaths, Road_injuries, Fireheatandhot,
 Meningitis, Alzheimer_dementias, Parkinson, Malaria, Maternal_disorders, HIV_AIDS, Tuberculosis, Lower_respiratory_infections, Neonatal_disorders, Diarrheal_diseases, Neoplasms, Diabetes_mellitus, Chronic_kidney_disease, Chronic_respiratory_diseases, Cirrhosis_chronic_liver_diseases, Digestive_diseases, Acute_hepatitis,
mytable.totaldeath_bynondisease, mytable.totaldeath_bydisease, newpercentable.Total_death, newpercentable.perbydisease, newpercentable.perbynondisease
FROM newpercentable
FULL OUTER JOIN mytable
ON mytable.Entity = newpercentable.Entity and mytable.Year = newpercentable.Year;


select * From newpercentable;

select * From mytable;