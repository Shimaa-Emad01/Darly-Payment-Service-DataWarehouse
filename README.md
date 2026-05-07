# Darly Payment Service Data Warehouse Analysis

## Project Overview
This project focuses on analyzing Darly payment service data using SQL and Google BigQuery while applying Data Warehouse concepts and optimization techniques.

The project aims to extract meaningful insights from users, providers, requests, and payments data to improve business understanding and system performance.

---

## Technologies Used
- SQL
- Google BigQuery
- Data Warehouse Concepts

---

## Dataset Tables
The analysis was performed using the following tables:

- Users
- Providers
- Services
- Provider_Service
- Requests
- Payments

---

## Project Features

### 1. Data Exploration
Previewing dataset structure and sample records.

### 2. Users & Providers Matching
Matching users with providers based on location.

### 3. Most Requested Services
Identifying the highest-demand services.

### 4. Requests Per User
Analyzing user activity and request frequency.

### 5. Payment Analysis
Analyzing total payments by payment methods.

### 6. Request Status Analysis
Comparing completed and cancelled requests.

### 7. Average Completion Time
Measuring service efficiency.

### 8. Average Response Time
Measuring provider responsiveness.

### 9. Location Analysis
Finding locations with the highest service demand.

### 10. Provider Availability
Analyzing provider distribution and availability.

### 11. Revenue Analysis
Calculating average completed payments.

---

## Stored Procedures

### GetUserPayments
Returns total payments for a specific user.

### GetRequestsByStatus
Returns requests grouped by their status.

---

## Query Optimization

### Partitioning
The Requests table was partitioned using:
- Request_Time

### Clustering
The table was clustered using:
- User_ID
- Req_Status

These techniques improve query performance and reduce processing cost.

---

## Learning Outcomes
Through this project, I practiced:

- SQL Joins
- Aggregation Functions
- Analytical Queries
- Stored Procedures
- Data Warehouse Optimization
- Partitioning & Clustering Techniques
- Business Data Analysis

---
**Shimaa Emad**

<img width="1919" height="980" alt="image" src="https://github.com/user-attachments/assets/3b6e435d-206d-47c2-8e39-1ead28d0400b" />

