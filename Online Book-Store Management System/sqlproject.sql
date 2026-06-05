--create database

CREATE DATABASE onlinebookstore;

--create tables

DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_id INT PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10,2),
    Stock INT
);

DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers (
    Customer_id INT PRIMARY KEY,
    Name VARCHAR(20),
    Email VARCHAR(100),
    Phone VARCHAR(20),
    City VARCHAR(20),
    Country VARCHAR(20)
);

DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
    Order_id INT PRIMARY KEY,
    Customer_id INT REFERENCES Customers(Customer_id),
    Book_id INT REFERENCES Books(Book_id),
    Order_date DATE,
    Quantity INT,
    Total_amount NUMERIC(10,2)
);

select * from Books;
select * from Customers;
select * from Orders;

--Import data into Books Table
copy Books(Book_id, Title, Author, Genre, Published_Year, Price, Stock)
from 'D:\All Excel Practice Files\Books.csv'
csv header;

--Import data into Customers Table
copy Customers(Customer_id, Name, Email, Phone, City, Country)
from '‪D:\All Excel Practice Files\Customers.csv'
csv header;

--Import data into Orders Table
copy Orders(Order_id, Customer_id, Book_id, Order_date, Quantity, Total_amount)
from '‪D:\All Excel Practice Files\Orders.csv'
csv header; 

-- 1) Retrive all books to the "fiction" genre:
select * from Books where genre='Fiction'

-- 2) Find the books published after the year 1950:
select * from Books where published_year>1950

-- 3) List all the Customers from the canada:
select * from Customers where country='Canada'

-- 4) show order placed in Novemeber 2023:
select * from Orders where extract(year from order_date)=2023 and extract(month from order_date)=22
--or--
select * from Orders where order_date between '01-11-2023' and '30-11-2023'

-- 5) Retrive the total stocks of books avliable:
select sum(stock) as total_stocks  from Books

-- 6) Find the detail about most expensive Book:
select * from Books order by price desc limit 1

-- 7) show customers who orders more than 6 quantity of Books:
select * from Orders where quantity>6

-- 8) Retrive all orders whose total_amount less than $60:
select * from Orders where total_amount<60

-- 9)  list the all genre avliable in books genre:
select genre from Books group by genre

-- 10) Find the books with the lowest stocks:
select * from Books order by stock asc limit 1

-- 11) calculate the total revanue granted from all orders:
select sum(total_amount) as total_revanue from orders

------------------Advanced Questions -------------------- 

-- 1) Retrive the Total no of books sold by each genre:
select Books.genre,sum(orders.quantity)
from Books
join Orders
on Books.Book_id=Orders.Book_id group by Books.genre

-- 2) find the avrage price of Books in the "Fantasy" genre:
select avg(price) from Books where genre='Fantasy'

-- 3) List the Customers who placed atleast 2 orders:
select Customers.name,count(Orders.order_id) 
from Customers 
join Orders 
on Customers.customer_id=Orders.Customer_id 
group by Customers.name 
having count(Orders.order_id)>2

-- 4) Find the Books most Frquently Orderd books:
select Books.title,count(Orders.order_id) 
from Books 
join Orders 
on Books.book_id=Orders.order_id  
group by Books.title 
order by count(Orders.order_id) 
desc limit 1

 -- 5) show the tp 3 most expensive books from 'Fanatasy genre':
select title from Books 
where genre='Fanatasy' 
order by price desc 
limit 3

-- 6) Retrive the Total quantity of Books sold by each genre:
select Books.author,sum(Orders.quantity) from Books 
join Orders 
on Book.book_id=Orders.order_id 
group by Books.author

--7) List the Cities where Customers who spent over $30 are located:
select distinct Customers.city,order.total_amount
from Customers 
join Orders 
on Customer.customer_id=Orders.Customer_id
where Orders.total_amount>$30

-- 8) Find Customers who spent more on orders
select Customers.name,sum(Orders.total_amount) 
from Customers 
join Orders 
on Customers.customer_id=Orders.Customer_id 
group by Customers.name 
order by sum(orders.total_amount) desc 
limit 1
 