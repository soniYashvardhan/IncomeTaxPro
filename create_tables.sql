SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

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