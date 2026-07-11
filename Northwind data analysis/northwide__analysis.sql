-- TABELS
-- ============================================
-- 1.categories
-- ============================================

DROP TABLE IF EXISTS categories;

CREATE TABLE categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(50),
    description TEXT
);

-- ============================================
-- 2.customers
-- ============================================

DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id VARCHAR(10) PRIMARY KEY,
    company_name VARCHAR(100),
    contact_name VARCHAR(100),
    contact_title VARCHAR(100),
    address TEXT,
    city VARCHAR(50),
    region VARCHAR(50),
    country VARCHAR(50)
);

-- ============================================
-- 3.employees
-- ============================================

DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    last_name VARCHAR(50),
    first_name VARCHAR(50),
    title VARCHAR(100),
    title_of_courtesy VARCHAR(50),
    birth_date DATE,
    hire_date DATE,
    address TEXT,
    city VARCHAR(50),
    region VARCHAR(50),
    country VARCHAR(50),
    home_phone VARCHAR(30),
    salary NUMERIC(10,2)
);

-- ============================================
-- 4.shippers
-- ============================================

DROP TABLE IF EXISTS shippers;

CREATE TABLE shippers (
    shipper_id INT PRIMARY KEY,
    company_name VARCHAR(100),
    phone VARCHAR(30)
);

-- ============================================
-- 5.suppliers
-- ============================================

DROP TABLE IF EXISTS suppliers;

CREATE TABLE suppliers (
    supplier_id INT PRIMARY KEY,
    company_name VARCHAR(100),
    contact_name VARCHAR(100),
    contact_title VARCHAR(100),
    address TEXT,
    city VARCHAR(50),
    region VARCHAR(50),
    postal_code VARCHAR(20),
    country VARCHAR(50)
);

-- ============================================
-- 6.region
-- ============================================

DROP TABLE IF EXISTS region;

CREATE TABLE region (
    region_id INT PRIMARY KEY,
    region_description VARCHAR(100)
);

-- ============================================
-- 7.territories
-- ============================================

DROP TABLE IF EXISTS territories;

CREATE TABLE territories (
    territory_id VARCHAR(20) PRIMARY KEY,
    territory_description VARCHAR(100),
    region_id INT,
    FOREIGN KEY (region_id) REFERENCES region(region_id)
);

-- ============================================
-- 8.products
-- ============================================

DROP TABLE IF EXISTS products;

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    supplier_id INT,
    category_id INT,
    quantity_per_unit VARCHAR(100),
    unit_price NUMERIC(10,2),
    units_in_stock INT,
    units_on_order INT,
    reorder_level INT,
    discontinued INT,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- ============================================
-- 9.employee_territories
-- ============================================

DROP TABLE IF EXISTS employee_territories;

CREATE TABLE employee_territories (
    employee_id INT,
    territory_id VARCHAR(20),
    PRIMARY KEY (employee_id, territory_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (territory_id) REFERENCES territories(territory_id)
);

-- ============================================
-- 10.orders
-- ============================================

DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id VARCHAR(10),
    employee_id INT,
    order_date DATE,
    required_date DATE,
    shipped_date DATE,
    ship_via INT,
    freight NUMERIC(10,2),
    ship_name VARCHAR(100),
    ship_address TEXT,
    ship_city VARCHAR(50),
    ship_region VARCHAR(50),
    ship_postal_code VARCHAR(20),
    ship_country VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (ship_via) REFERENCES shippers(shipper_id)
);

-- ============================================
-- 11.order_details
-- ============================================

DROP TABLE IF EXISTS order_details;

CREATE TABLE order_details (
    order_id INT,
    product_id INT,
    unit_price NUMERIC(10,2),
    quantity INT,
    discount NUMERIC(4,2),
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
select * from categories
select * from customers
select * from employee_territories
select * from employees
select * from order_details
select * from orders
select * from products
select * from region
select * from shippers
select * from suppliers
select * from territories

-- Find the top 5 most expensive products.
SELECT product_name, unit_price
FROM products
ORDER BY unit_price DESC
LIMIT 5;

-- Find all products that are currently out of stock.
select product_id,product_name,units_in_stock 
from products 
where units_in_stock=0

-- List all customers who are located in either the USA or the UK.
select customer_id,company_name,country from customers where country in('USA','UK')

-- Find all orders that were placed in the year 1997.
select order_id,customer_id,order_date 
from orders 
where extract(year from order_date)=1997

-- Find the total number of customers from each country.
select count(customer_id) as Total_customers,country 
from customers 
group by country

-- Find the total sales amount for each product.
SELECT product_id,SUM(unit_price * quantity * (1 - discount)) AS total_sales 
FROM order_details 
GROUP BY product_id;

-- Find the average unit price of products for each category
select category_id,round(avg(unit_price),2) as average_price 
from products 
group by category_id 

-- Find the number of products available in each category.
select category_id,count(product_id) as Total_category 
from products 
group by category_id

-- Find categories that have more than 10 products.
select category_id,count(product_id) as Total_category 
from products 
group by category_id 
having count(product_id)>10

-- Find the total sales amount generated by each customer.
select o.customer_id,sum(od.unit_price * od.quantity * (1 - od.discount)) as total_sales 
from orders as o join order_details as od 
on o.order_id=od.order_id 
group by o.customer_id

-- Find the top 5 customers who spent the most money.
select o.customer_id,round(sum(od.unit_price * od.quantity * (1-od.discount)),0) as total_sales 
from orders as o join order_details as od
on o.order_id=od.order_id
group by o.customer_id 
order by total_sales desc 
limit 5 

-- Find the total number of orders handled by each employee.
select employee_id,count(order_id) as total_order 
from orders 
group by employee_id

-- Find the employee who handled the highest number of orders.
select employee_id,count(order_id) as total_order 
from orders 
group by employee_id 
order by total_order desc 
limit 1

-- Find the total revenue generated in each year.
select
extract(year from o.order_date) as year,
sum(od.quantity * od.unit_price * (1 - od.discount)) as total_revenue
from orders as o
join order_details as od
on o.order_id = od.order_id
group by  extract (year from o.order_date);

-- Find the top 3 best-selling products based on quantity sold.
select product_id,sum(quantity) as total_quantity from 
order_details 
group by product_id 
order by total_quantity desc 
limit 3 

-- Find the average discount given on each product.
select product_id,avg(discount) as averge_discount from order_details group by product_id

-- Find all customers who have placed more than 5 orders.
select
 c.customer_id,
c.company_name,
count(o.order_id) as total_orders
from customers as c
join orders as o
on c.customer_id = o.customer_id
group by
c.customer_id,
 c.company_name
having count(o.order_id) > 5
order by total_orders desc;

-- Find products that have never been ordered.
select
p.product_id,
p.product_name
from products as p
left join order_details as od
on p.product_id = od.product_id
where od.product_id is null;

-- Find the top 3 categories by total sales.
select
c.category_name,
round(sum(od.unit_price * od.quantity * (1 - od.discount)), 2) as total_sales
from categories as c
join products as p
on c.category_id = p.category_id
join order_details as od
on p.product_id = od.product_id
group by
c.category_id,
c.category_name
order by total_sales desc
limit 3;

-- Assign a row number to products within each category based on unit price.
select
category_id,
product_name,
unit_price,
row_number() over (
partition by category_id
order by unit_price desc)
as ranking
from products;

-- Rank products within each category based on unit price.
select
category_id,
product_name,
unit_price,
rank() over (
partition by category_id
order by unit_price desc
) as ranking
from products;

-- Find the top 2 most expensive products in each category using a cte.
with ranked_products as (
    select
        category_id,
        product_name,
        unit_price,
        rank() over (
            partition by category_id
            order by unit_price desc
        ) as ranking
    from products
)

select
    category_id,
    product_name,
    unit_price,
    ranking
from ranked_products
where ranking <= 2
order by category_id, ranking;

-- Find the customers who have placed more than 10 orders.
select c.customer_id,c.company_name,count(o.order_id) as total_orders from customers as c join orders as o on c.customer_id=o.customer_id group by c.customer_id
having count(o.order_id)>10 order by total_orders desc limit 10

-- Find all products whose unit price is higher than the average unit price of their own category.
select p1.product_id,p1.product_name,p1.category_id,p1.unit_price from products as p1 where p1.unit_price >(select avg(p2.unit_price) from products as p2 where p1.category_id=p2.category_id)

-- Find all customers who have never placed an order.
select c.customer_id,c.company_name from customers as c  left join orders as o  on c.customer_id=o.customer_id where o.order_id is null

-- Find the suppliers who supply more than 5 products.
select s.supplier_id,s.company_name,count(p.product_id) as total_product from suppliers as s join products as p on s.supplier_id=p.supplier_id group by s.supplier_id,s.company_name having count(p.product_id)>5

-- Find the customer who spent the highest total amount.
select
c.customer_id,
c.company_name,
 round(sum(od.unit_price * od.quantity * (1 - od.discount)), 2) as total_spent
from customers as c
join orders as o
on c.customer_id = o.customer_id
join order_details as od
on o.order_id = od.order_id
group by
c.customer_id,c.company_name
order by total_spent desc
limit 1;

-- Find the average order value for each customer.
with order_totals as (
    select
        o.order_id,
        o.customer_id,
        sum(od.unit_price * od.quantity * (1 - od.discount)) as order_value
    from orders as o
    join order_details as od
        on o.order_id = od.order_id
    group by
        o.order_id,
        o.customer_id
)

select
    c.customer_id,
    c.company_name,
    round(avg(ot.order_value), 2) as average_order_value
from customers as c
join order_totals as ot
    on c.customer_id = ot.customer_id
group by
    c.customer_id,
    c.company_name
order by average_order_value desc;

-- Find the month that generated the highest total revenue.
select extract(month from o.order_date) as month,round(sum(od.quantity*od.unit_price*(1-od.discount)),2) as total_revenue from orders as o join order_details as od on o.order_id=od.order_id group by extract(month from o.order_date) order by total_revenue desc limit 1

-- Find the employee who generated the highest total sales


select e.employee_id,e.first_name,e.last_name,round(sum(od.quantity*od.unit_price*(1-od.discount)),2) as total_sales from employees as e join orders as o on e.employee_id=o.employee_id join order_details as od on o.order_id=od.order_id
group by e.employee_id,e.first_name,e.last_name order by total_sales desc limit 1

-- Find the top 5 customers based on the number of different products they purchased
    c.customer_id,
    c.company_name,
    count(distinct od.product_id) as total_products
from customers as c
join orders as o
    on c.customer_id = o.customer_id
join order_details as od
    on o.order_id = od.order_id
group by
    c.customer_id,
    c.company_name
order by total_products desc
limit 5;

-- Find the supplier who generated the highest total sales.
select
    s.supplier_id,
    s.company_name,
    round(sum(od.unit_price * od.quantity * (1 - od.discount)),2) as total_sales
from suppliers as s
join products as p
    on s.supplier_id = p.supplier_id
join order_details as od
    on p.product_id = od.product_id
group by
    s.supplier_id,
    s.company_name
order by total_sales desc
limit 1;

-- Find the category with the highest average product price.
select
    c.category_name,
    round(avg(p.unit_price),2) as average_price
from categories as c
join products as p
    on c.category_id = p.category_id
group by
    c.category_name
order by average_price desc
limit 1;

-- Find customers who purchased products from more than 3 different categories.
select
    c.customer_id,
    c.company_name,
    count(distinct p.category_id) as total_categories
from customers as c
join orders as o
    on c.customer_id = o.customer_id
join order_details as od
    on o.order_id = od.order_id
join products as p
    on od.product_id = p.product_id
group by
    c.customer_id,
    c.company_name
having count(distinct p.category_id) > 3
order by total_categories desc;

-- Find the average number of products per order.
select
    round(avg(product_count),2) as average_products_per_order
from
(
    select
        order_id,
        count(product_id) as product_count
    from order_details
    group by order_id
) as t;

-- Find products whose total sales are greater than the average total sales of all products.
select
    product_id,
    total_sales
from
(
    select
        product_id,
        sum(unit_price * quantity * (1 - discount)) as total_sales
    from order_details
    group by product_id
) as t
where total_sales >
(
    select
        avg(total_sales)
    from
    (
        select
            sum(unit_price * quantity * (1 - discount)) as total_sales
        from order_details
        group by product_id
    ) as x
)
order by total_sales desc;

