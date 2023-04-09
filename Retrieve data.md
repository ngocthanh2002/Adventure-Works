# 💼Adventure-Works

<h1 style="font-size:20px;"> 🚛Retrieve data for transportation reports</h1>

* Number of cities in database
````sql
select distinct City
from [SalesLT].[Address]

````
Answer:


* Number of State Province in database
````sql
select distinct StateProvince
from [SalesLT].[Address]
````

Answer:
Database have totally 25 StateProvinces 

* Number of Country Region in database
````sql
select distinct CountryRegion
from [SalesLT].[Address]
````

Answer:
Database have 3 CountryRegions such as Cananda, United Kingdom, United States.

* Number of Customer of each Country
````sql
with cus_country as (select cusad.CustomerID
    ,ad.AddressID
    ,ad.City
    ,ad.CountryRegion
    , COUNT (CustomerID) OVER ( PARTITION BY CountryRegion  ) AS number_cus
from  [SalesLT].[Address] as ad
join [SalesLT].[CustomerAddress] as cusad
on ad.AddressID = cusad.AddressID)
, number_customer as (
select CountryRegion
    , number_cus
    , row_number() over(PARTITION BY CountryRegion order by number_cus ) as number_customer
from cus_country)
 
select CountryRegion
    , number_cus
from number_customer
where number_customer = 1
````
Answer: 
Database have 107 ,38, 272 customers in Canada, United Kingdom, United States respectively.

