-- ============================================
-- Practice 3: Transactions & Concurrency Control
-- ============================================

-- Drop table if exists
DROP TABLE IF EXISTS StudentEnrollments;

-- Create Table
CREATE TABLE StudentEnrollments (
    student_id      INT PRIMARY KEY,
    student_name    VARCHAR(100),
    course_id       VARCHAR(10),
    enrollment_date DATE
);

-- Insert Sample Data
INSERT INTO StudentEnrollments (student_id, student_name, course_id, enrollment_date)
VALUES
(1, 'Ashish',  'CSE101', '2024-06-01'),
(2, 'Smaran',  'CSE102', '2024-06-01'),
(3, 'Vaibhav', 'CSE103', '2024-06-01');

-- ============================================
-- Part A: Simulating Deadlock (Run in two sessions)
-- ============================================

-- Session 1
-- START TRANSACTION;
-- UPDATE StudentEnrollments SET course_id = 'CSE201' WHERE student_id = 1;
-- UPDATE StudentEnrollments SET course_id = 'CSE202' WHERE student_id = 2;

-- Session 2
-- START TRANSACTION;
-- UPDATE StudentEnrollments SET course_id = 'CSE301' WHERE student_id = 2;
-- UPDATE StudentEnrollments SET course_id = 'CSE302' WHERE student_id = 1;

-- Deadlock occurs → One transaction will rollback automatically

-- ============================================
-- Part B: MVCC Demo (Run in two sessions)
-- ============================================

-- Session A (Reader)
-- SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
-- START TRANSACTION;
-- SELECT * FROM StudentEnrollments WHERE student_id = 1;

-- Session B (Writer)
-- START TRANSACTION;
-- UPDATE StudentEnrollments SET enrollment_date = '2024-07-10' WHERE student_id = 1;
-- COMMIT;

-- Session A continues to see old value until COMMIT
-- SELECT * FROM StudentEnrollments WHERE student_id = 1;
-- COMMIT;

-- ============================================
-- Part C: Compare With/Without MVCC
-- ============================================

-- Case 1: Traditional Locking (blocking)
-- Session X (Writer)
-- START TRANSACTION;
-- UPDATE StudentEnrollments SET course_id = 'CSE401' WHERE student_id = 1;

-- Session Y (Reader, blocking)
-- START TRANSACTION;
-- SELECT * FROM StudentEnrollments WHERE student_id = 1 FOR UPDATE;
-- COMMIT;

-- Case 2: MVCC (non-blocking)
-- Session X (Writer)
-- START TRANSACTION;
-- UPDATE StudentEnrollments SET course_id = 'CSE402' WHERE student_id = 1;

-- Session Y (Reader, non-blocking)
-- SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
-- START TRANSACTION;
-- SELECT * FROM StudentEnrollments WHERE student_id = 1;
-- COMMIT;

-- Commit Writer
-- COMMIT;

-- Final Check
SELECT * FROM StudentEnrollments;
