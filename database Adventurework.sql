-- Logistic manager
--Retrieve a list of cities
select * from [SalesLT].[Address]
select distinct AddressID
    , City
    , StateProvince
from [SalesLT].[Address]
order by StateProvince ASC , City DESC

--City
select distinct City
from [SalesLT].[Address]

-- State Province
select distinct StateProvince
from [SalesLT].[Address]

-- Country Region
select * from [SalesLT].[Address]
select distinct CountryRegion
from [SalesLT].[Address]

-- Customer of each Country
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
 
select * from number_customer
where number_customer = 1

-- Customer of each StateProvince
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
 
select * from number_customer
where number_customer = 1

--Retrieve the names, weight of the top ten percent of product by weight
select Top 10 percent ProductID 
    , [Name]
    , ProductNumber
    , [Weight]
from [SalesLT].[Product]
order by [Weight] DESC


---
--The Production Manager
--Retrieve the product number and name of the products 
--that have a color of black, red, or white and a size of S or M. 

select * from [SalesLT].[Product]


select [Name]
    , ProductNumber
    , Color
    , Size
from [SalesLT].[Product]
where (Color in ('Black','Red','White'))
    or (Size in  ('S','M'))

--Retrieve the ProductID, ProductNumber and Name of the products,
--that must have Product number begins with 'BK-' followed by any character other than 'T' 
--and ends with a '-' followed by any two numerals. 
--And satisfy one of the following conditions:
--color of black, red, or white 
--size is S or M and 


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

/* Retrieve specific products by product ID  
Retrieve the product ID, product number, name, and list price of products whose 
- product name contains "HL " or "Mountain", --> WHERE Name LIKE ...
- product number is at least 8 characters --> WHERE ProductNumber ... 
- and never have been ordered. */
SELECT DISTINCT ProductID , Name, ListPrice
FROM SalesLT.Product
WHERE 
   ( Name LIKE '%HL%' OR Name LIKE '%Mountain%')
    AND ProductNumber LIKE '________%' -- ít nhất 8 kí tự 
    AND ProductID NOT IN ( SELECT DISTINCT ProductID 
                            FROM SalesLT.SalesOrderDetail )


-- Color Product
select distinct Color
from [SalesLT].[Product]

--Size Product
select distinct Size
from [SalesLT].[Product]

-- Retrieve the heaviest products information
/*Transportation costs are increasing and you need to identify the heaviest products. Retrieve the names, weight of the top ten percent of products by weight. 
Then, add new column named Number of sell days (caculated from SellStartDate and SellEndDate) of these products (if sell end date isn't defined then get Today date)*/

select * from [SalesLT].[Product]
select top 10 percent ProductID
    , [Name]
    , [Weight]
    , SellStartDate
    , SellEndDate
    , IIF (SellEndDate is null , datediff (day, SellStartDate, CURRENT_TIMESTAMP),
            datediff(day,SellStartDate, SellEndDate)) as number_of_sell_days
from [SalesLT].[Product]
order by [Weight] desc

/*As you continue to work with the Adventure Works customer data, you must create queries for reports that have been requested by the sales team.
Retrieve a list of customer companies
You have been asked to provide a list of all customer companies in the format Customer ID : Company Name - for example, 78: Preferred Bikes*/

select * from [SalesLT].[Customer]
select CustomerID
    , CompanyName
    , CONCAT(CustomerID,': ',CompanyName) as formated_name
from [SalesLT].[Customer]

/*Retrieve a list of sales order revisions
The SalesLT.SalesOrderHeader table contains records of sales orders. You have been asked to retrieve data for a report that shows:
The sales order number and revision number in the format () – for example SO71774 (2).
The order date converted to ANSI standard 102 format (yyyy.mm.dd – for example 2015.01.31). */

select SalesOrderID
    , RevisionNumber
    , CONCAT (SalesOrderID,'(',RevisionNumber,')') as order_reivision_number
    , convert(nvarchar,OrderDate,102) as orderdate_ANSI
 from [SalesLT].[SalesOrderHeader]

/*Some records in the database include missing or unknown values that are returned as NULL. You must create some queries that handle these NULL values appropriately.
Retrieve customer contact names with middle names if known
You have been asked to write a query that returns a list of customer names. The list must consist of a single column in the format first last (for example Keith Harris) 
if the middle name is unknown, or first middle last (for example Jane M. Gates) if a middle name is known.*/

select * from [SalesLT].[Customer]
select FirstName
    , MiddleName
    , LastName
    , CONCAT(FirstName,' ',MiddleName,' ',LastName) as full_name
from [SalesLT].[Customer]
/*Retrieve primary contact details
Customers may provide Adventure Works with an email address, a phone number, or both.
If an email address is available, then it should be used as the primary contact method; 
if not, then the phone number should be used. You must write a query that returns a list of customer IDs in one column,
and a second column named PrimaryContact that contains the email address if known, and otherwise the phone number. */
Select CustomerID
    , EmailAddress
    , Phone
    ,IIF (EmailAddress is not null, EmailAddress,Phone) as primary_contact
from [SalesLT].[Customer]

/*As you continue to work with the Adventure Works customer, product and sales data, 
you must create queries for reports that have been requested by the sales team.
Retrieve a list of customers with no address
A sales employee has noticed that Adventure Works does not have address information for all customers. 
You must write a query that returns a list of customer IDs, company names, contact names (first name and last name), 
and phone numbers for customers with no address stored in the database.*/

select CustomerID
    , CompanyName
    , CONCAT(FirstName,' ',LastName) as contact_name
    ,Phone
from [SalesLT].[Customer]
where CustomerID not in (select distinct CustomerID from [SalesLT].[CustomerAddress] )

/*As an initial step towards generating the invoice report, 
write a query that returns the company name*/
select * from [SalesLT].[SalesOrderHeader]
select * from [SalesLT].[Customer]

select CompanyName
    , SalesOrderID
    , TotalDue
from [SalesLT].[Customer] as cus
join [SalesLT].[SalesOrderHeader] as header
on cus.CustomerID = header.CustomerID

/*Retrieve customer orders with addresses
Extend your customer orders query to include the Main Office address for each customer, 
including the full street address, city, state or province, postal code, and country or region */

select * from [SalesLT].[Address]
select * from [SalesLT].[CustomerAddress]

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
inner join SalesLT.SalesOrderHeader as header -- Lưu ý chỗ này : chỉ giữ lại các customer có đặt hàng 
    on cus.CustomerID = header.CustomerID
where AddressType = 'Main Office'

/* Task 2: Retrieve customer data
As you continue to work with the Adventure Works customer, product and sales data, 
you must create queries for reports that have been requested by the sales team.
  
Retrieve a list of products
○ A sales manager needs a list of ordered product with more information. 
You must write a query that returns a 
list of product name (is generated by the string preceded by the '-' character (example: HL Road Frame)), 
only started selling in 2006, Product model name contains "Road", 
CategoryName contains "Bikes" and  ListPrice value with integer part equal to 2443
*/
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

