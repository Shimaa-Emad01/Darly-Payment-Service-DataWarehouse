-- =========================================
-- 1. DATA EXPLORATION
-- Purpose: Preview dataset structure and sample data
-- =========================================

SELECT * FROM `darly01database.PaymentsDataset.Users` LIMIT 4;
SELECT * FROM `darly01database.PaymentsDataset.payments` LIMIT 4;
SELECT * FROM `darly01database.PaymentsDataset.Provider_Service` LIMIT 4;
SELECT * FROM `darly01database.PaymentsDataset.Requests` LIMIT 4;
SELECT * FROM `darly01database.PaymentsDataset.Services` LIMIT 4;
SELECT * FROM `darly01database.PaymentsDataset.Providers` LIMIT 4;

-- =========================================
-- 2. USERS & PROVIDERS (Same Location)
-- Purpose: Match users with nearby providers
-- =========================================

SELECT 
    u.Name AS user_name,
    u.Phone_No AS user_phone,
    u.Location,
    p.Name AS provider_name,
    p.Phone_No AS provider_phone

FROM `darly01database.PaymentsDataset.Users` u
JOIN `darly01database.PaymentsDataset.Providers` p
ON u.Location = p.Location

LIMIT 5;

-- =========================================
-- 3. MOST REQUESTED SERVICES
-- Purpose: Identify high demand services
-- =========================================

SELECT 
    s.Service_Name,
    COUNT(*) AS total_requests

FROM `darly01database.PaymentsDataset.Provider_Service` ps
JOIN `darly01database.PaymentsDataset.Services` s
ON ps.Service_ID = s.Service_ID

GROUP BY s.Service_Name
ORDER BY total_requests DESC;

-- =========================================
-- 4. REQUESTS PER USER
-- Purpose: Analyze user activity
-- =========================================

SELECT 
    u.Name,
    COUNT(r.Request_ID) AS total_requests

FROM `darly01database.PaymentsDataset.Users` u
JOIN `darly01database.PaymentsDataset.Requests` r
ON u.User_ID = r.User_ID

GROUP BY u.Name
ORDER BY total_requests DESC;

-- =========================================
-- 5. PAYMENT ANALYSIS
-- Purpose: Total payments by method
-- =========================================

SELECT 
    Payment_method,
    ROUND(SUM(Amount), 2) AS total_amount

FROM `darly01database.PaymentsDataset.payments`

GROUP BY Payment_method
ORDER BY total_amount DESC;

-- =========================================
-- 6. REQUEST STATUS ANALYSIS
-- Purpose: Completed vs Cancelled requests
-- =========================================

SELECT 
    Req_Status,
    COUNT(*) AS total_requests

FROM `darly01database.PaymentsDataset.Requests`

GROUP BY Req_Status;

-- =========================================
-- 7. AVERAGE COMPLETION TIME
-- Purpose: Measure service efficiency
-- =========================================

SELECT 
    ROUND(
        AVG(
            TIMESTAMP_DIFF(Completion_Time, Request_Time, MINUTE)
        ),
        2
    ) AS avg_completion_time_minutes

FROM `darly01database.PaymentsDataset.Requests`

WHERE Completion_Time IS NOT NULL;

-- =========================================
-- 8. AVERAGE RESPONSE TIME
-- Purpose: Measure provider responsiveness
-- =========================================

SELECT 
    ROUND(
        AVG(
            TIMESTAMP_DIFF(Response_Time, Request_Time, MINUTE)
        ),
        2
    ) AS avg_response_time

FROM `darly01database.PaymentsDataset.Requests`

WHERE Response_Time IS NOT NULL;

-- =========================================
-- 9. LOCATION ANALYSIS
-- Purpose: Find high demand locations
-- =========================================

SELECT 
    u.Location,
    COUNT(r.Request_ID) AS total_requests

FROM `darly01database.PaymentsDataset.Users` u
JOIN `darly01database.PaymentsDataset.Requests` r
ON u.User_ID = r.User_ID

GROUP BY u.Location
ORDER BY total_requests DESC;

-- =========================================
-- 10. PROVIDER AVAILABILITY
-- Purpose: Check provider distribution
-- =========================================

SELECT 
    Availability_Status,
    COUNT(*) AS total_providers

FROM `darly01database.PaymentsDataset.Providers`

GROUP BY Availability_Status;

-- =========================================
-- 11. COMPLETED PAYMENTS ONLY
-- Purpose: Real revenue analysis
-- =========================================

SELECT 
    ROUND(AVG(p.Amount), 2) AS avg_completed_payment

FROM `darly01database.PaymentsDataset.payments` p
JOIN `darly01database.PaymentsDataset.Requests` r
ON p.Request_ID = r.Request_ID

WHERE r.Req_Status = 'Completed';

--------------------------------------------------------------------------------------------------------------------------
-- Procedure 1 (User Payments)
-------------------------------------
CREATE OR REPLACE PROCEDURE `darly01database.PaymentsDataset.GetUserPayments`
(
    p_user_id INT64
)
BEGIN

SELECT 
    r.User_ID,
    ROUND(SUM(p.Amount), 2) AS total_payments

FROM `darly01database.PaymentsDataset.Requests` r
JOIN `darly01database.PaymentsDataset.payments` p
ON r.Request_ID = p.Request_ID

WHERE r.User_ID = p_user_id

GROUP BY r.User_ID;

END;

--
CALL `darly01database.PaymentsDataset.GetUserPayments`(5);


--------------------------------------------------------------------------------------------------------------------------
-- Procedure 2 (Requests by Status)
-------------------------------------
CREATE OR REPLACE PROCEDURE `darly01database.PaymentsDataset.GetRequestsByStatus`()
BEGIN

SELECT 
    Req_Status,
    COUNT(*) AS total_requests

FROM `darly01database.PaymentsDataset.Requests`

GROUP BY Req_Status;

END;
------
CALL `darly01database.PaymentsDataset.GetRequestsByStatus`();

-- =========================================
-- Partitioning & Clustering (CORRECT VERSION)
-- Purpose: Optimize large Requests table for performance
-- =========================================

CREATE OR REPLACE TABLE `darly01database.PaymentsDataset.requests_optimized`

PARTITION BY DATE(Request_Time)   -- تقسيم حسب وقت الطلب

CLUSTER BY User_ID, Req_Status     -- ترتيب داخلي لتحسين البحث

AS

SELECT *
FROM `darly01database.PaymentsDataset.Requests`;

