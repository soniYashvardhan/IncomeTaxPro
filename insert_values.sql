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