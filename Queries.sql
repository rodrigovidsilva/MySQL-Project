/*1. List all the customer’s names, dates, and products or services used/booked/rented/bought by
these customers in a range of two dates. */

SELECT CONCAT(c.FIRST_NAME, ' ', c.LAST_NAME) AS COSTUMER_NAME, o.`DATE` AS ORDER_DATE, i.MODEL AS PRODUCT FROM `customer` c
JOIN `order` o ON c.CUSTOMER_ID = o.CUSTOMER_ID
JOIN `order_line` ol ON o.ORDER_ID = ol.ORDER_ID
JOIN `item` i ON ol.ITEM_ID = i.ITEM_ID
WHERE o.`DATE` BETWEEN '2022-01-05' AND '2023-11-04';
    


/*2. List the best three customers/products/services/places (you are free to define the criteria for
what means “best”) - for us, best is the one that spent the most */

SELECT c.CUSTOMER_ID, CONCAT(c.FIRST_NAME, ' ', c.LAST_NAME) AS CUSTOMER_NAME, SUM(o.TOTAL_PRICE) AS TOTAL_SPENDING FROM `customer` c
JOIN `order` o ON c.CUSTOMER_ID = o.CUSTOMER_ID
GROUP BY c.CUSTOMER_ID
ORDER BY TOTAL_SPENDING DESC
LIMIT 3;



/*3. Get the average amount of sales/bookings/rents/deliveries for a period that involves 2 or more
years, as in the following example. This query only returns one record. */

SELECT
    CONCAT(MIN(DATE_FORMAT(o.DATE, '%m/%Y')), ' – ', MAX(DATE_FORMAT(o.DATE, '%m/%Y'))) AS PeriodOfSales,
    SUM(o.TOTAL_PRICE) AS TotalSales,
    ROUND(SUM(o.TOTAL_PRICE) / COUNT(DISTINCT DATE_FORMAT(o.DATE, '%Y')), 2) AS YearlyAverage,
    ROUND(SUM(o.TOTAL_PRICE) / DATEDIFF(MAX(o.DATE), MIN(o.DATE) + 1) * 30, 2) AS MonthlyAverage
FROM `order` o
WHERE o.DATE BETWEEN '2022-01-05' AND '2023-11-04';
    


/* 4. Get the total sales/bookings/rents/deliveries by geographical location (city/country).*/

SELECT c.CITY, c.COUNTRY_ID, SUM(o.TOTAL_PRICE) AS TotalSales FROM `order` o
JOIN `customer` c ON o.CUSTOMER_ID = c.CUSTOMER_ID
GROUP BY c.CITY, c.COUNTRY_ID;
    


/*5. List all the locations where products/services were sold, and the product has customer’s ratings */

SELECT c.CITY, c.COUNTRY_ID, ROUND(AVG(i.RATING_ITEM),2) AS AVG_RATING_PER_LOCATION FROM `order` o
JOIN `order_line` ol ON o.ORDER_ID = ol.ORDER_ID
JOIN `item` i ON ol.ITEM_ID = i.ITEM_ID
JOIN `customer` c ON o.CUSTOMER_ID = c.CUSTOMER_ID
WHERE i.RATING_ITEM IS NOT NULL
GROUP BY c.CITY, c.COUNTRY_ID;


---------------------------------------------
--Queries for triggers
---------------------------------------------

/* Trigger for order to supplier (trigger 1) */

SELECT * FROM SYW.ORDER_SUPPLIER
ORDER BY ORDER_SUP_ID DESC
LIMIT 3;

SELECT ITEM_ID, STOCK FROM item where item_id = 5;

INSERT INTO `order_supplier` (`DATE`, `SUPPLIER_ID`, `ITEM_ID`, `SUPPLY_QUANTITY`, `SUPPLY_PRICE`) VALUES
('2023-11-30', 5, 5, 3, 310.85);

SELECT * FROM SYW.ORDER_SUPPLIER
ORDER BY ORDER_SUP_ID DESC
LIMIT 3;

SELECT ITEM_ID, STOCK FROM item where item_id = 5;



/* Trigger for client order and log table update (triggers 2 and 3) */

SELECT * FROM SYW.ORDER
ORDER BY ORDER_ID DESC
LIMIT 3;

SELECT * FROM SYW.ORDER_LINE
order by ORDER_ID DESC
LIMIT 3;

SELECT ITEM_ID, STOCK FROM item 
where item_id = 17;

INSERT INTO `order` (`DATE`, `CUSTOMER_ID`, `PROMO_ID`, `TOTAL_PRICE`, `RATING`) VALUES
('2023-12-04', 20, 9, 450.00, NULL);
INSERT INTO `order_line` (`ORDER_ID`, `ITEM_ID`, `QUANTITY`) VALUES
(25, 17, 2);

SELECT * FROM SYW.ORDER
ORDER BY ORDER_ID DESC
LIMIT 3;

SELECT * FROM SYW.ORDER_LINE
order by ORDER_ID DESC
LIMIT 3;

SELECT ITEM_ID, STOCK FROM item 
where item_id = 17;

select * from log;

