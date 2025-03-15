-- HR Schema Creation
CREATE TABLE employees (
    employee_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(50),
    last_name VARCHAR2(50),
    email VARCHAR2(100) UNIQUE,
    hire_date DATE NOT NULL,
    job_id VARCHAR2(10),
    salary NUMBER(10, 2)
);

CREATE TABLE departments (
    department_id NUMBER PRIMARY KEY,
    department_name VARCHAR2(50) NOT NULL,
    manager_id NUMBER,
    FOREIGN KEY (manager_id) REFERENCES employees(employee_id)
);

CREATE TABLE jobs (
    job_id VARCHAR2(10) PRIMARY KEY,
    job_title VARCHAR2(50),
    min_salary NUMBER(10, 2),
    max_salary NUMBER(10, 2)
);

-- Populate Sample Data
INSERT INTO jobs VALUES ('IT_PROG', 'Programmer', 4000, 8000);
INSERT INTO employees VALUES (1, 'John', 'Doe', 'john.doe@example.com', SYSDATE, 'IT_PROG', 6000);
INSERT INTO departments VALUES (10, 'IT', 1);

