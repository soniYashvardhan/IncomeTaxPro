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



-- SELECT  income.income_type_id, CapitalAssets.assest_type, CapitalAssets.profit, CapitalAssets.gain
-- FROM income NATURAL JOIN CapitalAssets
-- WHERE income.income_type_id = 30001;	

-- SELECT  income.income_type_id, SUM(CapitalAssets.profit), SUM(CapitalAssets.gain)
-- FROM income NATURAL JOIN CapitalAssets
-- WHERE income.income_type_id = 30001
-- GROUP BY income.income_type_id;