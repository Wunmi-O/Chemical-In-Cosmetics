--Prior cleaning was done with Microsoft Excel Power Query Editor before importing into SQL server and Tableau.

--Find out which chemicals were used the most in cosmetics and personal care products
SELECT
	"ChemicalName",
	COUNT ("ChemicalName") AS "Number"
FROM public."Chemicals_In_Cosmetics"
WHERE "PrimaryCategory" = 'Personal Care Products'
GROUP BY "ChemicalName"
ORDER BY "Number" DESC;

--Find out which companies used the most reported chemicals in their cosmetics and personal care products
SELECT
	"CompanyName",
	COUNT ("ChemicalName") AS "Number"
FROM public."Chemicals_In_Cosmetics"
WHERE "ChemicalName" = 'Titanium dioxide' AND "PrimaryCategory" = 'Personal Care Products'
GROUP BY "CompanyName"
ORDER BY "Number" DESC;

--Which brands had chemicals that were removed and discontinued? Identify the chemicals
SELECT
	"BrandName"
	"ChemicalName"
FROM public."Chemicals_In_Cosmetics"
WHERE "DiscontinuedDate" IS NOT NULL AND "ChemicalDateRemoved" IS NOT NULL
GROUP BY "ChemicalName",
		"BrandName";

--Identify the brands that had chemicals which were mostly reported in 2018
SELECT 
	"BrandName",
	COUNT ("ChemicalName") AS "Number"
FROM public."Chemicals_In_Cosmetics" 
WHERE EXTRACT(YEAR FROM "InitialDateReported") = 2018
GROUP BY "BrandName"
ORDER BY "Number" DESC;

--Which brands had chemicals discontinued and removed?
SELECT 
	"BrandName",
	"ChemicalName"
FROM public."Chemicals_In_Cosmetics"
WHERE "DiscontinuedDate" IS NOT NULL AND "ChemicalDateRemoved" IS NOT NULL
GROUP BY "BrandName", "ChemicalName";

--Identify the period between the creation of the removed chemicals and when they were actually removed
SELECT 
	"CompanyName",
	"BrandName",
	"ProductName",
	"PrimaryCategory",
	"CSF",
	"ChemicalName",
	("ChemicalDateRemoved" - "ChemicalCreatedAt") AS "Period_Diff_Removed_Chemicals"
FROM public."Chemicals_In_Cosmetics"
WHERE "ChemicalDateRemoved" IS NOT NULL AND "ChemicalCreatedAt" IS NOT NULL
GROUP BY "CompanyName","BrandName","ProductName","PrimaryCategory","CSF","ChemicalName","Period_Diff_Removed_Chemicals";

--Can you tell if discontinued chemicals in bath products were removed?
SELECT 
	"CompanyName",
	"BrandName",
	"ProductName",
	"CSF",
	"ChemicalName",
	"ChemicalDateRemoved",
	"DiscontinuedDate"
FROM public."Chemicals_In_Cosmetics"
WHERE 
	"PrimaryCategory"='Bath Products' AND
	("ChemicalDateRemoved" IS NOT NULL AND "DiscontinuedDate" IS NOT NULL);
SELECT COUNT(*)
FROM public."Chemicals_In_Cosmetics"
WHERE 
	"PrimaryCategory"='Bath Products' AND 
	("ChemicalDateRemoved" IS NOT NULL AND "DiscontinuedDate" IS NOT NULL);
SELECT COUNT(*)
FROM public."Chemicals_In_Cosmetics"
WHERE 
	"PrimaryCategory"='Bath Products' AND 
	"DiscontinuedDate" IS NOT NULL; /*Out of the 552 discontinued chemicals, only 68 were actually removed*/

--How long were removed chemicals in baby products used?
SELECT 
	"CompanyName",
	"BrandName",
	"ProductName",
	"CSF",
	"ChemicalName",
	("ChemicalDateRemoved" - "ChemicalCreatedAt") AS "Usage_Period"
FROM public."Chemicals_In_Cosmetics"
WHERE 
	"PrimaryCategory" = 'Baby Products' AND 
	"ChemicalDateRemoved" IS NOT NULL;

--Identify the relationship between chemicals that were mostly recently reported and discontinued. (Does most recently reported chemicals equal discontinuation of such chemicals?)
SELECT 
	"ChemicalName",
	COUNT ("DiscontinuedDate") AS "NumberDiscontinued",
	COUNT ("MostRecentDateReported") AS "NumberRecentReport"
FROM public."Chemicals_In_Cosmetics"
GROUP BY 
	"ChemicalName"
ORDER BY "NumberRecentReport" DESC; /* No, most recent reported chemical does not equate discontinuation of those chemicals. Amongst the top 7, only Titanium dioxide(1) and Butylated hydroxyanisole(5) maintained their position across both periods*/ 

--Identify the relationship between CSF and chemicals used in the most manufactured sub categories. (Tip: Which chemicals gave a certain type of CSF in sub categories?
SELECT
	"SubCategory",
	"CSF",
	"ChemicalName",
	COUNT ("CSF") AS "NumberCSF"
FROM public."Chemicals_In_Cosmetics"
GROUP BY 
	"SubCategory",
	"CSF",
	"ChemicalName"
ORDER BY "NumberCSF" DESC; /*Titanium Dioxide is used to produce most 'Light' for the 'Foundations and Bases' subcategory*/ 
