CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    full_name VARCHAR(100),
    department VARCHAR(50),
    role VARCHAR(50),
    hourly_rate DECIMAL(10, 2)
);

CREATE TABLE Tasks (
    task_id INT PRIMARY KEY,
    task_name VARCHAR(100),
    priority VARCHAR(20),
    estimated_hours DECIMAL(5, 2),
    department VARCHAR(50)
);

CREATE TABLE Process_Logs (
    log_id INT PRIMARY KEY,
    task_id INT,
    employee_id INT,
    start_time DATETIME,
    end_time DATETIME,
    status VARCHAR(20),
    FOREIGN KEY (task_id) REFERENCES Tasks(task_id),
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
);

INSERT INTO Employees VALUES
(101, 'أحمد المنصور', 'Operations', 'Senior Specialist', 45.00),
(102, 'سارة الغامدي', 'Operations', 'Data Analyst', 35.00),
(103, 'خالد العتيبي', 'IT Support', 'Systems Engineer', 40.00),
(104, 'منى الحربي', 'HR & Admin', 'HR Specialist', 30.00),
(105, 'عمر الزهراني', 'Operations', 'Junior Specialist', 25.00),
(106, 'فاطمة الشهري', 'Finance', 'Financial Analyst', 38.00);

INSERT INTO Tasks VALUES
(501, 'System Access & Onboarding', 'High', 2.0, 'HR & Admin'),
(502, 'Financial Audit Verification', 'Critical', 5.0, 'Finance'),
(503, 'Operational Workflow Review', 'Medium', 8.0, 'Operations'),
(504, 'Database Server Migration', 'Critical', 12.0, 'IT Support'),
(505, 'Procurement Request Processing', 'High', 4.0, 'Operations');

INSERT INTO Process_Logs VALUES
(1001, 503, 101, '2026-08-01 08:00:00', '2026-08-01 17:00:00', 'Completed'),
(1002, 503, 105, '2026-08-01 08:30:00', '2026-08-02 12:00:00', 'Completed'),
(1003, 501, 104, '2026-08-02 09:00:00', '2026-08-02 11:30:00', 'Completed'),
(1004, 502, 106, '2026-08-03 08:00:00', '2026-08-03 16:00:00', 'Completed'),
(1005, 504, 103, '2026-08-04 10:00:00', '2026-08-06 14:00:00', 'Completed'),
(1006, 505, 102, '2026-08-05 08:00:00', '2026-08-05 15:00:00', 'Completed'),
(1007, 503, 105, '2026-08-06 08:00:00', '2026-08-07 16:00:00', 'Completed');



SELECT 
    e.department,
    t.task_name,
    COUNT(l.log_id) AS total_executed_tasks,
    AVG(t.estimated_hours) AS avg_estimated_hours,
    ROUND(AVG((JULIANDAY(l.end_time) - JULIANDAY(l.start_time)) * 24), 2) AS avg_actual_hours,
    ROUND(AVG((JULIANDAY(l.end_time) - JULIANDAY(l.start_time)) * 24) - AVG(t.estimated_hours), 2) AS avg_delay_hours
FROM Process_Logs l
JOIN Tasks t ON l.task_id = t.task_id
JOIN Employees e ON l.employee_id = e.employee_id
GROUP BY e.department, t.task_name
HAVING avg_delay_hours > 0
ORDER BY avg_delay_hours DESC;




SELECT 
    e.employee_id,
    e.full_name,
    e.department,
    SUM(ROUND(((JULIANDAY(l.end_time) - JULIANDAY(l.start_time)) * 24) - t.estimated_hours, 2)) AS total_idle_or_delay_hours,
    ROUND(SUM((((JULIANDAY(l.end_time) - JULIANDAY(l.start_time)) * 24) - t.estimated_hours) * e.hourly_rate), 2) AS total_financial_loss_usd
FROM Process_Logs l
JOIN Tasks t ON l.task_id = t.task_id
JOIN Employees e ON l.employee_id = e.employee_id
WHERE ((JULIANDAY(l.end_time) - JULIANDAY(l.start_time)) * 24) > t.estimated_hours
GROUP BY e.employee_id, e.full_name, e.department
ORDER BY total_financial_loss_usd DESC;















WITH RECURSIVE seq(n) AS (
    SELECT 1008
    UNION ALL
    SELECT n + 1 FROM seq WHERE n < 8500
)
INSERT INTO Process_Logs (log_id, task_id, employee_id, start_time, end_time, status)
SELECT 
    n AS log_id,
    ((n % 5) + 501) AS task_id,
    ((n % 6) + 101) AS employee_id,
    DATETIME('2025-08-01 08:00:00', '+' || n || ' hours') AS start_time,
    DATETIME('2025-08-01 08:00:00', '+' || (n + (CASE WHEN n % 3 = 0 THEN ((n % 10) + 12) ELSE ((n % 4) + 2) END)) || ' hours') AS end_time,
    'Completed' AS status
FROM seq;
