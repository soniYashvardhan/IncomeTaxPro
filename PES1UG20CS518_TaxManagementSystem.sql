--Name: Yash Vardhan Soni
--SRN: PES1UG20CS518
--Topic: Tax Management System
--Section: I

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

--Code for creating Tables

CREATE TABLE `User` (
	`user_id` int(5) NOT NULL,
	`FName` varchar(20) NOT NULL,
	`LName` varchar(20) DEFAULT NULL,
	`Age` int DEFAULT NULL,
	`Phone_no` int(10) DEFAULT NULL,
	`Address Permanent` varchar(255) NOT NULL,
	`Address Residentual` varchar(255) DEFAULT NULL,
	`income_id` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `Income` (
	`income_id` varchar(10) NOT NULL,
  	`tax_slab` int DEFAULT NULL,
	`total_tax` int DEFAULT NULL,
	`total_income` int DEFAULT NULL,
	`income_type` varchar(20) NOT NULL,
	`income_type_id` int(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `Salary` (
	`income_type_id` int(5) NOT NULL,
	`Gross Salary` int DEFAULT NULL,
	`CTC` int DEFAULT NULL,
	`taxable_amt` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `Insurance` (
	`id` int NOT NULL,
	`type` varchar(20) DEFAULT NULL,
	`Name` varchar(255) NOT NULL,
	`age` int DEFAULT NULL,
	`duration` int DEFAULT NULL,
	`amt` int DEFAULT NULL,
	`income_type_id` int(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `Allowances` (
	`allowance_id` int NOT NULL,
	`allowance_type` varchar(10) DEFAULT NULL,
	`allowance_amt` int DEFAULT NULL,
	`date_when_claimed` DATE DEFAULT NULL,
	`income_type_id` int(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `Reimbursements` (
	`reimbursement_id` int NOT NULL,
	`type` varchar(20) DEFAULT NULL,
	`amt` int DEFAULT NULL,
	`date` DATE DEFAULT NULL,
	`income_type_id` int(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `CapitalAssets` (
	`ca_id` int NOT NULL,
	`assest_type` varchar(20) DEFAULT NULL,
	`profit` int DEFAULT NULL,
	`gain` int DEFAULT NULL,
	`income_type_id` int(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `Real_estate` (
	`id` int NOT NULL,
	`location` varchar(255) DEFAULT NULL,
	`Purchase_date` DATE DEFAULT NULL,
	`Sell_date` DATE DEFAULT NULL,
	`price` int DEFAULT NULL,
	`ca_id` int(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `Stocks` (
	`id` int NOT NULL,
	`stock_symbol` varchar(20) DEFAULT NULL,
	`Purchase_date` DATE DEFAULT NULL,
	`Sell_date` DATE DEFAULT NULL,
	`quantity` int DEFAULT NULL,
	`amt` int DEFAULT NULL,
	`ca_id` int(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `Bonds` (
	`id` int NOT NULL,
	`type` varchar(20) DEFAULT NULL,
	`Purchase_date` DATE DEFAULT NULL,
	`duration` int DEFAULT NULL,
	`amount` int DEFAULT NULL,
	`ca_id` int(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `income_from_ca` (
	`income_id` varchar(10) NOT NULL,
	`income_type_id` int(5) NOT NULL,
	`total_income_sources` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--Code for adding primary and foreign keys

ALTER TABLE `User`
	ADD PRIMARY KEY(user_id),
	ADD KEY(income_id);
ALTER TABLE `Income`
	ADD PRIMARY KEY(income_id,income_type_id),
	ADD UNIQUE KEY(income_type_id);
ALTER TABLE `Salary`
	ADD PRIMARY KEY(income_type_id);
ALTER TABLE `Insurance`
	ADD PRIMARY KEY(id);
ALTER TABLE `Allowances`
	ADD PRIMARY KEY(allowance_id);
ALTER TABLE `Reimbursements`
	ADD PRIMARY KEY(reimbursement_id);
ALTER TABLE `CapitalAssets`
	ADD PRIMARY KEY(ca_id);
ALTER TABLE `Real_estate`
	ADD PRIMARY KEY(id);
ALTER TABLE `Stocks`
	ADD PRIMARY KEY(id);
ALTER TABLE `Bonds`
	ADD PRIMARY KEY(id);
ALTER TABLE `income_from_ca`
	ADD PRIMARY KEY(income_id,income_type_id);


-- ALTER TABLE `User`
-- 	ADD CONSTRAINT `User_ibfk1` FOREIGN KEY(income_id) REFERENCES Income(income_id) on DELETE CASCADE;
ALTER TABLE `Income`
	ADD CONSTRAINT `Income_ibfk1` FOREIGN KEY(income_id) REFERENCES User(income_id) on DELETE CASCADE;
ALTER TABLE `Salary`
	ADD CONSTRAINT `Salary_ibfk1` FOREIGN KEY(income_type_id) REFERENCES Income(income_type_id) on DELETE CASCADE;
ALTER TABLE `Insurance`
	ADD CONSTRAINT `Insurance_ibfk1` FOREIGN KEY(income_type_id) REFERENCES Income(income_type_id) on DELETE CASCADE;
ALTER TABLE `Allowances`
	ADD CONSTRAINT `Allowances_ibfk1` FOREIGN KEY(income_type_id) REFERENCES Income(income_type_id) on DELETE CASCADE;
ALTER TABLE `Reimbursements`
	ADD CONSTRAINT `Reimbursements_ibfk1` FOREIGN KEY(income_type_id) REFERENCES Income(income_type_id) on DELETE CASCADE;
ALTER TABLE `CapitalAssets`
	ADD CONSTRAINT `CapitalAssets_ibfk1` FOREIGN KEY(income_type_id) REFERENCES Income(income_type_id) on DELETE CASCADE;
ALTER TABLE `Real_estate`
	ADD CONSTRAINT `Real_estate_ibfk1` FOREIGN KEY(ca_id) REFERENCES CapitalAssets(ca_id) on DELETE CASCADE;
ALTER TABLE `Stocks`
	ADD CONSTRAINT `Stocks_ibfk1` FOREIGN KEY(ca_id) REFERENCES CapitalAssets(ca_id) on DELETE CASCADE;
ALTER TABLE `Bonds`
	ADD CONSTRAINT `Bonds_ibfk1` FOREIGN KEY(ca_id) REFERENCES CapitalAssets(ca_id) on DELETE CASCADE;
ALTER TABLE `income_from_ca`
	ADD CONSTRAINT `income_from_ca_ibfk1` FOREIGN KEY(income_id) REFERENCES User(income_id) on DELETE CASCADE,
	ADD CONSTRAINT `income_from_ca_ibfk2` FOREIGN KEY(income_type_id) REFERENCES Income(income_type_id) on DELETE CASCADE;
COMMIT;


-- Inserting values into the tables
LOAD DATA INFILE 'D:/Yash Vardhan Soni/PES/DBMS/MiniProject/User.csv' INTO TABLE `user` FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE 'D:/Yash Vardhan Soni/PES/DBMS/MiniProject/Income.csv' INTO TABLE `Income` FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE 'D:/Yash Vardhan Soni/PES/DBMS/MiniProject/Salary.csv' INTO TABLE `Salary` FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE 'D:/Yash Vardhan Soni/PES/DBMS/MiniProject/CapitalAssets.csv' INTO TABLE `CapitalAssets` FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

INSERT INTO `Insurance` (`id`, `type`, `Name`,`age`,`duration`,`amt`,`income_type_id`) VALUES
(1, 'Health Insurance', 'James King', 42, 3, 10000, 30000),
(2, 'Health Insurance', 'Marina King', 80, 10, 20000, 30000),
(3, 'Health Insurance', 'Dweep Sharma', 48, 3, 7000, 30100);

INSERT INTO `Allowances` (`allowance_id`, `allowance_type`, `allowance_amt`,`date_when_claimed`,`income_type_id`) VALUES
(1, 'HRA', 400000,'2020-04-01', 30000),
(2, 'LTA', 200000, '2020-04-02', 30000),
(3, 'Educational & Hostel', 9600, '2020-04-01', 30100);

INSERT INTO `Reimbursements` (`reimbursement_id`, `type`, `amt`, `date`, `income_type_id`) VALUES
(1, 'Internet', 10000, '2020-08-16', 30000),
(2, 'Cellphone', 2000, '2020-05-17', 30000);

INSERT INTO `Real_estate` (`id`, `location`, `Purchase_date`, `Sell_date`, `price`, `ca_id`) VALUES
(1, 'Pannalal Terrace, Shop No 7 Grant Road X Lane, Grant Road, Mumbai', '2010-03-15', '2018-06-03', 200000, 101),
(2, '540,1st Street, Gandhipuram, Coimbatore', '2014-04-07', '2020-08-31', 150000, 105);

INSERT INTO `Stocks` (`id`, `stock_symbol`, `Purchase_date`, `Sell_date`, `quantity`, `amt`, `ca_id`) VALUES
(1, 'TITAN', '2015-07-10', '2015-10-10', 100, 70000, 102),
(2, 'TATAMOTORS', '2018-02-14', '2020-01-26', 85, 50000, 104);

INSERT INTO `Bonds` (`id`, `type`, `Purchase_date`, `duration`, `amount`, `ca_id`) VALUES
(1, 'Gold', '2011-05-01', 10, 100000, 103),
(2, 'RBI', '2014-05-01', 5, 300000, 106);

INSERT INTO `income_from_ca` (`income_id`,`income_type_id`,`total_income_sources`) VALUES
('ABCDS1452D', 30001, 2),
('DRFTY1478O', 30201, 2),
('GHIRE5634A', 30500, 2);


INSERT INTO `User` (`user_id`,`Fname`,`Lname`,`Age`,`Phone_no`,`Address Permanent`,`Address Residentual`,`income_id`) VALUES
(99999,'hera','modi',99,9999999999,'Delhi','Delhi','AAAAA9999A');


--Code to Perform Different Operations
--JOIN
SELECT user.user_id, user.Fname, user.LName, income.total_tax, income.total_income, income.income_type, income.income_type_id
FROM user NATURAL JOIN income;

SELECT U.Fname as Employee_Fname, U.Lname as Employee_Lname, I.name as Dependent_Name, I.age Dependent_Age, I.duration, I.amt as Insurance_amount, I.type as Insurance_type
FROM User U NATURAL JOIN (Salary S NATURAL JOIN Insurance I);

SELECT  income.income_type_id, CapitalAssets.assest_type, CapitalAssets.profit, CapitalAssets.gain
FROM income INNER JOIN CapitalAssets ON income.income_type_id = CapitalAssets.income_type_id
WHERE income.income_type_id = 30001;

SELECT user.user_id, user.Fname, user.LName, CapitalAssets.assest_type, CapitalAssets.profit, CapitalAssets.gain
FROM user NATURAL JOIN (income NATURAL JOIN CapitalAssets)
WHERE assest_type like "Stocks";


--Aggregate
SELECT income.income_id, SUM(income.total_income) as income, SUM(income.total_tax) as tax
FROM income
GROUP BY income_id;

SELECT income_type_id, i_amt + a_amt + r_amt as total_amt_exempted
FROM (SELECT income_type_id, SUM(amt) as i_amt FROM Insurance GROUP BY income_type_id) I NATURAL JOIN (SELECT * FROM (SELECT income_type_id,SUM(allowance_amt) as a_amt FROM Allowances GROUP BY income_type_id) A NATURAL JOIN (SELECT income_type_id,SUM(amt) as r_amt FROM Reimbursements GROUP BY income_type_id) R) X;

SELECT ca_id, SUM(amt) as total_gain
FROM Stocks
GROUP BY ca_id;

SELECT ca_id, SUM(price) as total_gain
FROM Real_estate
GROUP BY ca_id;


--SET Operations
Select income_type_id,amt from Insurance UNION select income_type_id,allowance_amt from Allowances;

Select income_type_id,amt from Insurance INTERSECT select income_type_id,amt from Reimbursements;

Select income_type_id,amt from Insurance EXCEPT select income_type_id,allowance_amt from Allowances;

Select income_type_id from Insurance EXCEPT (select distinct income_type_id from CapitalAssets);

--Procedure
DELIMITER $$
CREATE PROCEDURE update_total_tax(IN id VARCHAR(30), IN type_id int, OUT msg VARCHAR(50))
BEGIN
    SET @inc_type = "";
	SELECT income_type INTO @inc_type
	FROM income
	WHERE income.income_id like id AND income.income_type_id = type_id;

	IF @inc_type like "Capital Assets" THEN
		SET @after_tax = 0;
		SET @before_tax = 0;

		SELECT SUM(CapitalAssets.profit) INTO @after_tax
		FROM income NATURAL JOIN CapitalAssets
		WHERE income.income_type_id = type_id
		GROUP BY income.income_type_id;

		SELECT SUM(CapitalAssets.gain) INTO @before_tax
		FROM income NATURAL JOIN CapitalAssets
		WHERE income.income_type_id = type_id
		GROUP BY income.income_type_id;

		UPDATE income
		SET total_tax = @before_tax - @after_tax
		WHERE income.income_id = id AND income.income_type_id = type_id;

    	SET msg = 'Total tax has been updated.';
	ELSE
    	SET msg = 'No functionality for Salary type of income!' ;
    END IF;
END; $$
DELIMITER ;

CALL update_total_tax('ABCDS1452D', 30001, @A);
SELECT @A;

SELECT * 
FROM income
WHERE income_id = 'ABCDS1452D';


-- Function
DELIMITER $$
CREATE FUNCTION no_of_assets(type_id INT)
RETURNS INT
DETERMINISTIC 
BEGIN
	DECLARE n int default 0;
	SELECT COUNT(*) into n
	FROM CapitalAssets
	WHERE CapitalAssets.income_type_id = type_id
	GROUP BY CapitalAssets.income_type_id;

	RETURN n;
END; $$
DELIMITER;

SELECT U.Fname, U.LName, no_of_assets(I.income_type_id)
FROM user U NATURAL JOIN income I
WHERE I.income_type like "Capital Assets";


-- Trigger
DELIMITER $$ 
CREATE TRIGGER date_check 
BEFORE INSERT  
ON Stocks FOR EACH ROW   
BEGIN   
    DECLARE err_msg VARCHAR(255);   
    SET err_msg = ('Sell Date is before purchase date');   
    IF new.Purchase_date > new.Sell_date THEN   
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = err_msg;
    END IF;   
END $$    
DELIMITER ;

insert into Stocks values (3,'EXIDEIND','2012-03-16','2012-02-13',16,100,107); 
insert into Stocks values (3,'EXIDEIND','2010-03-16','2012-02-13',16,100,107);


DELIMITER $$ 
CREATE TRIGGER total_tax 
BEFORE INSERT  
ON income FOR EACH ROW   
BEGIN   
    DECLARE err_msg VARCHAR(255);   
    SET err_msg = ('Sell Date is before purchase date');
	SET new.total_tax = 0;
    IF new.total_income > 500000 THEN   
    SET new.total_tax = 20 * new.total_income/100;
    END IF;   
END $$    
DELIMITER ;

insert into income values(`HFYUH4587K`, 20, 0, 700000, 'Salary', 30100)

-- Cursor (Backup Income table)
CREATE table `backup_income`(
	`income_id` varchar(10) NOT NULL,
  	`tax_slab` int DEFAULT NULL,
	`total_tax` int DEFAULT NULL,
	`total_income` int DEFAULT NULL,
	`income_type` varchar(20) NOT NULL,
	`income_type_id` int(5) NOT NULL
	)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DELIMITER //
CREATE PROCEDURE backup()
BEGIN
	DECLARE done INT DEFAULT 0;
	DECLARE income_id, income_type varchar(20);
	DECLARE tax_slab, total_tax, total_income, income_type_id INTEGER;
	DECLARE cur CURSOR FOR SELECT * FROM income;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
	OPEN cur;
	label: LOOP
	FETCH cur INTO income_id, tax_slab, total_tax, total_income, income_type, income_type_id;
	INSERT INTO backup_income VALUES(income_id, tax_slab, total_tax, total_income, income_type, income_type_id);
	IF done = 1 THEN LEAVE label;
	END IF;
	END LOOP;
	CLOSE cur;
	END//
DELIMITER ;

CALL backup;