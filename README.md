# SQL-PowerBI-PowerQuerry
I have conducted a comprehensive analysis of the provided sales dataset using Excel, SQL, and Power BI to derive meaningful insights and recommendations. My approach focused on data cleaning, transformation, and visualization to uncover key trends, anomalies, and business opportunities.

## SQL
* I basically used MySQL, created database/tables,  loaded data from the raw excel by using the load data infile. 
* Created another table similar to the original table - just as a back-up.
* Identified Missing values in the Quantity column. 
* Conducted a similar query for all the other columns and found that Unit_Price also had missing rows.
* Used JOIN to compare and apply similar values in the missing Unit_Price.
* Further proceeded to check for Duplicates and removed them using DUPLICATE_CTE.


## POWERQUERRY
* After extracting the clean data from SQL,
* I tabulated the data into group and analyze the quantity, frequency and sales output and prepared visuals of the same.
* Prepared a time series plot and extracted the top performers from the data set
* Furthermore I conducted a predictive analysis (based on ** Exponential Triple Smoothing **) of the future outcome of sales
* With the customers segmented into Low, Medium and High, I presented recommendations on how to engage them so as to foster better relationship in the future
* I also detected spikes while doing trend analysis with a possible explanation of the same.
* Other items of concern were: How to prioritize the best performing product with the aim of increasing sales, analyze customers' frequency of orders and how to improve them and inventory management

## POWER BI (Business Intelligence)
* Leveraged this tool to assist me in preparing interactive dashboards for presentation to the relevant personnel. 


