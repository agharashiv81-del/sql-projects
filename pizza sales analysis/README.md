Project Overview

This project focuses on analyzing pizza sales data using SQL (PostgreSQL).
The dataset contains information about orders, pizzas, pizza types, and order details.
The goal is to extract meaningful business insights using joins, aggregations, and subqueries.

 Tools Used
PostgreSQL
SQL (Joins, Subqueries, Aggregations)
CSV Data Import Tool (PgAdmin / PostgreSQL Import Feature)

 Database Schema
1. Orders Table
order_id (Primary Key)
date
time

3. Pizza_Types Table
pizza_type_id (Primary Key)
name
category
ingredients

4. Pizzas Table
pizza_id (Primary Key)
pizza_type_id (Foreign Key)
size
price

5. Order_Details Table
order_details_id (Primary Key)
order_id (Foreign Key)
pizza_id (Foreign Key)
quantity

🔗 Relationships

One order → multiple order details
One pizza type → multiple pizzas
One pizza → multiple order details
📊 Key SQL Analysis Performed

 Basic Analysis
Total number of orders placed
Category-wise pizza count
Highest priced pizza
Most common pizza size ordered

 Revenue Analysis
Total revenue generated
Revenue by pizza size
Top 3 pizzas by revenue
Top 5 most ordered pizza types

 Advanced Insights
Average pizzas ordered per day
Hourly order distribution
Category-wise quantity sold
Pizzas priced above average price

 Key Learnings
SQL Joins (INNER JOIN)
Subqueries
GROUP BY & Aggregations
Data analysis using real-world datasets
Revenue & sales analysis techniques

 Project Outcome
This project demonstrates how SQL can be used to:
Analyze sales data
Extract business insights
Understand customer behavior
Improve decision-making

Author
Shiv Aghara
