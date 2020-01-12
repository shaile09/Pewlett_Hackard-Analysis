--Number of titles retiring---

SELECT  e.emp_no,
        e.first_name,
        e.last_name,
        titles.title,
        titles.from_date,
	titles.to_date,
        s.salary
        
INTO retiringtitles_challenge
FROM employees AS e
    INNER JOIN titles
        ON (e.emp_no = titles.emp_no)
    INNER JOIN salaries AS s
        ON (e.emp_no = s.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-01-01')
AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--- Most recent titles--- More effiecient way to retrive data  

Create table mostrecent_challenge as (
select title, COUNT(emp_no) as num_cnt FROM
(SELECT emp_no, first_name, last_name, first_name, title, from_date, salary,
    ROW_NUMBER() OVER
(PARTITION BY (emp_no) ORDER BY from_date DESC) rn
  FROM retiringtitles_challenge
 )
 tmp WHERE rn = 1
 GROUP BY title);
 

--- Another approch --- create new table with recent retiring titles (seperted by new table)----

CREATE TABLE outputrecenretiring as (
	WITH retiringtitles_challenge AS
(
	SELECT emp_no, first_name, last_name, title, from_date, salary,
		 ROW_NUMBER() OVER
	(PARTITION BY (emp_no, first_name, last_name) ORDER BY from_date DESC) AS rnum
		  FROM retiringtitles_challenge
		  )
SELECT * FROM retiringtitles_challenge WHERE rnum = 1);

SELECT COUNT(title), title 
--INTO count_titles
FROM outputrecenretiring
GROUP BY title;

-- Who's Ready for a Mentor?
SELECT  e.emp_no,
        e.first_name,
        e.last_name,
        titles.title,
        titles.from_date,
        titles.to_date
        
INTO mentor_challenge
FROM employees AS e
    INNER JOIN titles
        ON (e.emp_no = titles.emp_no)
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
    AND (titles.to_date = '9999-01-01');
SELECT COUNT(emp_no)
FROM mentor_challenge;
