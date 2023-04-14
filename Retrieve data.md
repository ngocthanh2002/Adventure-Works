# 💼Adventure-Works

<h1 style="font-size:20px;"> 🚛Retrieve data for transportation reports</h1>

* Number of cities in database
````sql
select distinct City
from [SalesLT].[Address]

````
Answer:

<picture>
  <img  src="https://user-images.githubusercontent.com/129776645/231954328-acdb2d80-c23d-4a57-a84d-8b9475a5cc0d.png">
</picture>
 
 
 <p>There are 269 cities in the database</p>

* Number of State Province in database
````sql
select distinct StateProvince
from [SalesLT].[Address]
````

Answer:


<picture>
 <img src ="https://user-images.githubusercontent.com/129776645/231957248-6db02da3-f26c-45f2-8bc4-6c6d1a6f300e.png">
</picture>
 
Database have totally 25 StateProvinces 

* Number of Country Region in database
````sql
select distinct CountryRegion
from [SalesLT].[Address]
````

Answer:

<picture>
 <img src ="https://user-images.githubusercontent.com/129776645/231958746-0726c274-f860-4a47-9d94-f84c6098bda0.png">
</picture>
 


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


<picture>
 <img src ="https://user-images.githubusercontent.com/129776645/231959371-be35c4bf-8a38-4aef-9fab-7846f778e338.png">
</picture>
 


Database have 107 ,38, 272 customers in Canada, United Kingdom, United States respectively.


* Number of Customer of each StateProvince
````sql
with cus_country as (select cusad.CustomerID
    ,ad.AddressID
    ,ad.City
    ,ad.CountryRegion
    ,ad.StateProvince
    , COUNT (CustomerID) OVER ( PARTITION BY StateProvince  ) AS number_cus
from  [SalesLT].[Address] as ad
join [SalesLT].[CustomerAddress] as cusad
on ad.AddressID = cusad.AddressID)
, number_customer as (
select StateProvince
    , number_cus
    , row_number() over(PARTITION BY StateProvince order by number_cus ) as number_customer
from cus_country)
 
select StateProvince
    , number_cus
from number_customer
where number_customer = 1
````

Answer:


<picture>
 <img src ="https://user-images.githubusercontent.com/129776645/231960498-09d2227f-6d6e-40bd-93e7-19b9a756fb1c.png">
</picture>



* Retrieve the names, weight of the top ten percent of product by weight
````sql
select Top 10 percent ProductID 
    , [Name]
    , ProductNumber
    , [Weight]
from [SalesLT].[Product]
order by [Weight] DESC
````
Answer:

<picture>
 <img src ="https://user-images.githubusercontent.com/129776645/231960750-c710b13b-e7ee-4f31-aeda-8f5c818a7622.png">
</picture>


<h1 style="font-size:20px;"> 🕴️The Production Manager</h1>

* Retrieve the product number and name of the products that have a color of black, red, or white and a size of S or M.

````sql
select [Name]
    , ProductNumber
    , Color
    , Size
from [SalesLT].[Product]
where (Color in ('Black','Red','White'))
    or (Size in  ('S','M'))
````
Answer: 


<picture>
 <img src ="https://user-images.githubusercontent.com/129776645/231960976-4e4a76e5-107b-456f-a104-07d97c5ee77f.png">
</picture>

* Retrieve the ProductID, ProductNumber and Name of the products, that must have Product number begins with 'BK-' followed by any character other than 'T'  and ends with a '-' followed by any two numerals. 
And satisfy one of the following conditions: color of black, red, or white , size is S or M


````sql
select ProductID
    , [Name]
    , ProductNumber
    , Color
    , Size
from [SalesLT].[Product]
where ProductNumber like 'BK-%'
    and ProductNumber not like '____T%'
    and ProductNumber like '%-[0-9][0-9]'
    and ((Color in ('Black','Red','White'))
    or (Size in  ('S','M')))
````
Answer:

<picture>
 <img src ="https://user-images.githubusercontent.com/129776645/231961792-ae0b7de0-9e63-40ac-80e2-6652d6f8cff6.png">
</picture>

* Retrieve specific products by product ID  
Retrieve the product ID, product number, name, and list price of products whose 
 product name contains "HL " or "Mountain", 
 product number is at least 8 characters  and never have been ordered.

````sql
SELECT DISTINCT ProductID , Name, ListPrice
FROM SalesLT.Product
WHERE 
   ( Name LIKE '%HL%' OR Name LIKE '%Mountain%')
    AND ProductNumber LIKE '________%' -- at least 8 characters
    AND ProductID NOT IN ( SELECT DISTINCT ProductID 
                            FROM SalesLT.SalesOrderDetail )
````
Answer:

<picture>
 <img src ="https://user-images.githubusercontent.com/129776645/231961933-b2d942a4-dede-4bae-9341-bc75a86ebfac.png">
</picture>

* Color Product
````sql
select distinct Color
from [SalesLT].[Product]
````

Answer:

<picture>
 <img src ="https://user-images.githubusercontent.com/129776645/231962152-4e3ec583-488c-477b-96cb-ceb729aae567.png">
</picture>

* Size Product
````sql
select distinct Size
from [SalesLT].[Product]
````

Answer:

<picture>
 <img src ="https://user-images.githubusercontent.com/129776645/231962232-67e91e2d-b152-4fb8-a084-fb09e063cac0.png">
</picture>



* Retrieve the heaviest products information
Transportation costs are increasing and you need to identify the heaviest products. Retrieve the names, weight of the top ten percent of products by weight. 
Then, add new column named Number of sell days (caculated from SellStartDate and SellEndDate) of these products (if sell end date isn't defined then get Today date)


````sql
select top 10 percent ProductID
    , [Name]
    , [Weight]
    , SellStartDate
    , SellEndDate
    , IIF (SellEndDate is null , datediff (day, SellStartDate, CURRENT_TIMESTAMP),
            datediff(day,SellStartDate, SellEndDate)) as number_of_sell_days
from [SalesLT].[Product]
order by [Weight] desc
````

Answer:


<picture>
 <img src ="https://user-images.githubusercontent.com/129776645/231962483-d8bde8bb-1d33-4caa-9a90-37bbc6c6ec74.png">
</picture>




As you continue to work with the Adventure Works customer data, you must create queries for reports that have been requested by the sales team.
Retrieve a list of customer companies
You have been asked to provide a list of all customer companies in the format Customer ID : Company Name - for example, 78: Preferred Bikes

````sql
select CustomerID
    , CompanyName
    , CONCAT(CustomerID,': ',CompanyName) as formated_name
from [SalesLT].[Customer]

````

Answer:

<picture>
 <img src ="https://user-images.githubusercontent.com/129776645/231962750-67e3362f-d4a1-4e1e-b68b-f1a7578a9eba.png">
</picture>


* Retrieve a list of sales order revisions
The SalesLT.SalesOrderHeader table contains records of sales orders. You have been asked to retrieve data for a report that shows:
The sales order number and revision number in the format () – for example SO71774 (2).
The order date converted to ANSI standard 102 format (yyyy.mm.dd – for example 2015.01.31).

````sql
select SalesOrderID
    , RevisionNumber
    , CONCAT (SalesOrderID,'(',RevisionNumber,')') as order_reivision_number
    , convert(nvarchar,OrderDate,102) as orderdate_ANSI
 from [SalesLT].[SalesOrderHeader]


````

Answer:


<picture>
 <img src ="https://user-images.githubusercontent.com/129776645/231963018-8489780e-e312-4fc0-8d8a-4f1998a55cad.png">
</picture>


* Some records in the database include missing or unknown values that are returned as NULL. You must create some queries that handle these NULL values appropriately.
Retrieve customer contact names with middle names if known
You have been asked to write a query that returns a list of customer names. The list must consist of a single column in the format first last (for example Keith Harris) 
if the middle name is unknown, or first middle last (for example Jane M. Gates) if a middle name is known

````sql
select FirstName
    , MiddleName
    , LastName
    , CONCAT(FirstName,' ',MiddleName,' ',LastName) as full_name
from [SalesLT].[Customer]
````


Answer:


<picture>
 <img src ="https://user-images.githubusercontent.com/129776645/231963235-9167f5a8-e49e-4122-9b8d-8b69a1f935c7.png">
</picture>


* Retrieve primary contact details
Customers may provide Adventure Works with an email address, a phone number, or both.
If an email address is available, then it should be used as the primary contact method; 
if not, then the phone number should be used. You must write a query that returns a list of customer IDs in one column,
and a second column named PrimaryContact that contains the email address if known, and otherwise the phone number.

````sql
select CustomerID
    , EmailAddress
    , Phone
    ,IIF (EmailAddress is not null, EmailAddress,Phone) as primary_contact
from [SalesLT].[Customer]

````

Answer:

<picture>
 <img src ="https://user-images.githubusercontent.com/129776645/231963615-47ab8aa7-3218-40b6-b4bd-56f25bdc7966.png">
</picture>


* As you continue to work with the Adventure Works customer, product and sales data, 
you must create queries for reports that have been requested by the sales team.
Retrieve a list of customers with no address
A sales employee has noticed that Adventure Works does not have address information for all customers. 
You must write a query that returns a list of customer IDs, company names, contact names (first name and last name), 
and phone numbers for customers with no address stored in the database.

````sql

select CustomerID
    , CompanyName
    , CONCAT(FirstName,' ',LastName) as contact_name
    ,Phone
from [SalesLT].[Customer]
where CustomerID not in (select distinct CustomerID from [SalesLT].[CustomerAddress] )

````

Answer:


<picture>
 <img src ="https://user-images.githubusercontent.com/129776645/231964029-88500a12-031e-423d-b99f-771eea3cec26.png">
</picture>



* As an initial step towards generating the invoice report, write a query that returns the company name

````sql

select CompanyName
    , SalesOrderID
    , TotalDue
from [SalesLT].[Customer] as cus
join [SalesLT].[SalesOrderHeader] as header
on cus.CustomerID = header.CustomerID

````
Answer:


<picture>
 <img src ="https://user-images.githubusercontent.com/129776645/231964029-88500a12-031e-423d-b99f-771eea3cec26.png">
</picture>


*Retrieve customer orders with addresses
Extend your customer orders query to include the Main Office address for each customer, 
including the full street address, city, state or province, postal code, and country or region

````sql

select  
    cus.CustomerID
    , AddressLine1
    , City
    , StateProvince 
    , CountryRegion
    , PostalCode
from SalesLT.Customer as cus -- 847 dòng 
left join SalesLT.CustomerAddress as cus_address -- 417
    on cus.CustomerID = cus_address.CustomerID
left join SalesLT.Address as adress 
    on cus_address.AddressID = adress.AddressID
inner join SalesLT.SalesOrderHeader as header 
    on cus.CustomerID = header.CustomerID
where AddressType = 'Main Office'

````
Answer:


<picture>
 <img src ="https://user-images.githubusercontent.com/129776645/231964891-59bd3676-8baf-40fe-8524-9cf462cc3e9f.png">
</picture>


* Task 2: Retrieve customer data
As you continue to work with the Adventure Works customer, product and sales data, 
you must create queries for reports that have been requested by the sales team.
  
Retrieve a list of products
○ A sales manager needs a list of ordered product with more information. 
You must write a query that returns a 
list of product name (is generated by the string preceded by the '-' character (example: HL Road Frame)), 
only started selling in 2006, Product model name contains "Road", 
CategoryName contains "Bikes" and  ListPrice value with integer part equal to 2443



````sql

select detail.ProductID 
    , pro.Name 
    , cat.name as cat_name 
    , model.name as model_name 
    , IIF (CHARINDEX ('-', pro.Name) = 0, pro.Name, SUBSTRING (pro.Name, 1, CHARINDEX ('-', pro.Name) - 1 ) ) AS product_name 
from SalesLT.SalesOrderDetail as detail 
left join  SalesLT.Product as pro 
    on detail.ProductID = pro.ProductID 
left join SalesLT.ProductModel as model 
   on pro.ProductModelID = model.ProductModelID
left join SalesLT.ProductCategory as cat 
    on pro.ProductCategoryID = cat.ProductCategoryID
where YEAR (SellStartDate) = 2006
    and model.Name like '%Road%'
    and cat.Name like '%Bikes%'
    and CAST (ListPrice as int) = 2443

````


Answer:


<picture>
 <img src ="https://user-images.githubusercontent.com/129776645/231965281-86c26518-574a-4f0f-98cc-87b2f4a44ef1.png">
</picture>

















