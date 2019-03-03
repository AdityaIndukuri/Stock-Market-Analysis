#Changing the date format for all tables under schema assignment
UPDATE assignment.bajaj SET DATE = STR_TO_DATE(Date, "%d-%M-%Y");
UPDATE assignment.eicher SET DATE = STR_TO_DATE(Date, "%d-%M-%Y");
UPDATE assignment.hero SET DATE = STR_TO_DATE(Date, "%d-%M-%Y");
UPDATE assignment.infosys SET DATE = STR_TO_DATE(Date, "%d-%M-%Y");
UPDATE assignment.tcs SET DATE = STR_TO_DATE(Date, "%d-%M-%Y");
UPDATE assignment.tvs SET DATE = STR_TO_DATE(Date, "%d-%M-%Y");

####Task1: Creating new tables bajaj1, eicher1, hero1, infosys1, tcs1, tvs1 from existing tables
CREATE TABLE assignment.bajaj1 AS
   select Date, `Close Price`, 
	avg(`Close Price`) over(ORDER BY `date` rows between 19 PRECEDING AND CURRENT ROW) as `20 Day MA`,
	avg(`Close Price`) over(ORDER BY `date` rows between 49 PRECEDING AND CURRENT ROW) as `50 Day MA`
   FROM assignment.bajaj
   ORDER BY date asc;
    
#Ingnoring first 49 rows as it is not possible to calculate the required Moving Averages
DELETE FROM bajaj1 LIMIT 49;

CREATE TABLE assignment.eicher1 AS
   select Date, `Close Price`, 
	avg(`Close Price`) over(ORDER BY `date` rows between 19 PRECEDING AND CURRENT ROW) as `20 Day MA`,
	avg(`Close Price`) over(ORDER BY `date` rows between 49 PRECEDING AND CURRENT ROW) as `50 Day MA`
   FROM assignment.eicher
   ORDER BY date asc;

#Ingnoring first 49 rows as it is not possible to calculate the required Moving Averages
DELETE FROM eicher1 LIMIT 49;

CREATE TABLE assignment.hero1 AS
   select Date, `Close Price`, 
	avg(`Close Price`) over(ORDER BY `date` rows between 19 PRECEDING AND CURRENT ROW) as `20 Day MA`,
	avg(`Close Price`) over(ORDER BY `date` rows between 49 PRECEDING AND CURRENT ROW) as `50 Day MA`
   FROM assignment.hero
   ORDER BY date asc;

#Ingnoring first 49 rows as it is not possible to calculate the required Moving Averages
DELETE FROM hero1 LIMIT 49;

CREATE TABLE assignment.infosys1 AS
   select Date, `Close Price`, 
	avg(`Close Price`) over(ORDER BY `date` rows between 19 PRECEDING AND CURRENT ROW) as `20 Day MA`,
	avg(`Close Price`) over(ORDER BY `date` rows between 49 PRECEDING AND CURRENT ROW) as `50 Day MA`
   FROM assignment.infosys
   ORDER BY date asc;

#Ingnoring first 49 rows as it is not possible to calculate the required Moving Averages
DELETE FROM infosys1 LIMIT 49;

CREATE TABLE assignment.tcs1 AS
   select Date, `Close Price`, 
	avg(`Close Price`) over(ORDER BY `date` rows between 19 PRECEDING AND CURRENT ROW) as `20 Day MA`,
	avg(`Close Price`) over(ORDER BY `date` rows between 49 PRECEDING AND CURRENT ROW) as `50 Day MA`
   FROM assignment.tcs
   ORDER BY date asc;

#Ingnoring first 49 rows as it is not possible to calculate the required Moving Averages
DELETE FROM tcs1 LIMIT 49;

CREATE TABLE assignment.tvs1 AS
   select Date, `Close Price`, 
	avg(`Close Price`) over(ORDER BY `date` rows between 19 PRECEDING AND CURRENT ROW) as `20 Day MA`,
	avg(`Close Price`) over(ORDER BY `date` rows between 49 PRECEDING AND CURRENT ROW) as `50 Day MA`
   FROM assignment.tvs
   ORDER BY date asc;

#Ingnoring first 49 rows as it is not possible to calculate the required Moving Averages
DELETE FROM tvs1 LIMIT 49;

####Task2: Creating master table containing the date and close price for all the six stocks.

CREATE TABLE assignment.master AS
	select Date,
    `Close Price` as  Bajaj FROM assignment.bajaj1
	 ORDER BY date asc;

ALTER TABLE assignment.master ADD COLUMN TCS double;
UPDATE assignment.master INNER JOIN assignment.tcs1 ON assignment.master.Date = assignment.tcs1.Date
SET assignment.master.TCS = assignment.tcs1.`Close Price`; 

ALTER TABLE assignment.master ADD COLUMN TVS double;
UPDATE assignment.master INNER JOIN assignment.tvs1 ON assignment.master.Date = assignment.tvs1.Date
SET assignment.master.TVS = assignment.tvs1.`Close Price`; 

ALTER TABLE assignment.master ADD COLUMN Infosys double;
UPDATE assignment.master INNER JOIN assignment.infosys1 ON assignment.master.Date = assignment.infosys1.Date
SET assignment.master.Infosys = assignment.infosys1.`Close Price`; 

ALTER TABLE assignment.master ADD COLUMN Eicher double;
UPDATE assignment.master INNER JOIN assignment.eicher1 ON assignment.master.Date = assignment.eicher1.Date
SET assignment.master.Eicher = assignment.eicher1.`Close Price`; 

ALTER TABLE assignment.master ADD COLUMN Hero double;
UPDATE assignment.master INNER JOIN assignment.hero1 ON assignment.master.Date = assignment.hero1.Date
SET assignment.master.Hero = assignment.hero1.`Close Price`; 

######Task3: Generate hold, buy and sell signal for all 6 stocks
#Create a table bajaj2 with previous day MA column
CREATE TABLE assignment.bajaj2 
select *,
lag(`20 Day MA`,1) over w as `Prev 20 Day MA`,
lag(`50 Day MA`,1) over w as `Prev 50 Day MA`
from bajaj1
window w as (partition by 'Close Price' order by Date);

#Create a table bajaj3 with signal logic
CREATE TABLE assignment.bajaj3
select Date,
case 
when `20 Day MA` > `50 Day MA` and
	  `Prev 20 Day MA` < `Prev 50 Day MA` then 'BUY'

when `20 Day MA` < `50 Day MA` and
	  `Prev 20 Day MA` > `Prev 50 Day MA` then 'SELL'
else 'HOLD'

end AS `Signal`
FROM bajaj2;

#Join Signal column with bajaj2 table
ALTER TABLE assignment.bajaj2 ADD COLUMN `Signal` char(255);
UPDATE bajaj2 LEFT JOIN bajaj3 ON bajaj2.Date = bajaj3.Date
SET bajaj2.Signal = bajaj3.Signal;

#Dropping bajaj3 tabble
drop table bajaj3;

#Removing unnecessary columns from bajaj2
ALTER TABLE bajaj2 DROP column `20 Day MA`, DROP column `50 Day MA`, DROP column `Prev 20 Day MA`, DROP column `Prev 50 Day MA`;

##Create a table eicher2 with previous day MA column
CREATE TABLE assignment.eicher2 
select *,
lag(`20 Day MA`,1) over w as `Prev 20 Day MA`,
lag(`50 Day MA`,1) over w as `Prev 50 Day MA`
from eicher1
window w as (partition by 'Close Price' order by Date);

#Create a table eicher3 with signal logic
CREATE TABLE assignment.eicher3 
select Date,
case 
when `20 Day MA` > `50 Day MA` and
	  `Prev 20 Day MA` < `Prev 50 Day MA` then 'BUY'

when `20 Day MA` < `50 Day MA` and
	  `Prev 20 Day MA` > `Prev 50 Day MA` then 'SELL'
else 'HOLD'

end AS `Signal`
FROM eicher2;

#Join Signal column with eicher2 table
ALTER TABLE assignment.eicher2 ADD COLUMN `Signal` char(255);
UPDATE eicher2 LEFT JOIN eicher3 ON eicher2.Date = eicher3.Date
SET eicher2.Signal = eicher3.Signal;

#Dropping eicher3 tabble
drop table eicher3;

#Removing unnecessary columns from eicher2
ALTER TABLE eicher2 DROP column `20 Day MA`, DROP column `50 Day MA`, DROP column `Prev 20 Day MA`, DROP column `Prev 50 Day MA`;

##Create a table hero2 with previous day MA column
CREATE TABLE assignment.hero2 
select *,
lag(`20 Day MA`,1) over w as `Prev 20 Day MA`,
lag(`50 Day MA`,1) over w as `Prev 50 Day MA`
from hero1
window w as (partition by 'Close Price' order by Date);

#Create a table hero3 with signal logic
CREATE TABLE assignment.hero3 
select Date,
case 
when `20 Day MA` > `50 Day MA` and
	  `Prev 20 Day MA` < `Prev 50 Day MA` then 'BUY'

when `20 Day MA` < `50 Day MA` and
	  `Prev 20 Day MA` > `Prev 50 Day MA` then 'SELL'
else 'HOLD'

end AS `Signal`
FROM hero2;

#Join Signal column with hero2 table
ALTER TABLE assignment.hero2 ADD COLUMN `Signal` char(255);
UPDATE hero2 LEFT JOIN hero3 ON hero2.Date = hero3.Date
SET hero2.Signal = hero3.Signal;

#Dropping hero3 tabble
drop table hero3;

#Removing unnecessary columns from hero2
ALTER TABLE hero2 DROP column `20 Day MA`, DROP column `50 Day MA`, DROP column `Prev 20 Day MA`, DROP column `Prev 50 Day MA`;

##Create a table infosys2 with previous day MA column
CREATE TABLE assignment.infosys2 
select *,
lag(`20 Day MA`,1) over w as `Prev 20 Day MA`,
lag(`50 Day MA`,1) over w as `Prev 50 Day MA`
from infosys1
window w as (partition by 'Close Price' order by Date);

#Create a table infosys3 with signal logic
CREATE TABLE assignment.infosys3 
select Date,
case 
when `20 Day MA` > `50 Day MA` and
	  `Prev 20 Day MA` < `Prev 50 Day MA` then 'BUY'

when `20 Day MA` < `50 Day MA` and
	  `Prev 20 Day MA` > `Prev 50 Day MA` then 'SELL'
else 'HOLD'

end AS `Signal`
FROM infosys2;

#Join Signal column with infosys2 table
ALTER TABLE assignment.infosys2 ADD COLUMN `Signal` char(255);
UPDATE infosys2 LEFT JOIN infosys3 ON infosys2.Date = infosys3.Date
SET infosys2.Signal = infosys3.Signal;

#Dropping infosys3 tabble
drop table infosys3;

#Removing unnecessary columns from infosys2
ALTER TABLE infosys2 DROP column `20 Day MA`, DROP column `50 Day MA`, DROP column `Prev 20 Day MA`, DROP column `Prev 50 Day MA`;


##Create a table tcs2 with previous day MA column
CREATE TABLE assignment.tcs2 
select *,
lag(`20 Day MA`,1) over w as `Prev 20 Day MA`,
lag(`50 Day MA`,1) over w as `Prev 50 Day MA`
from tcs1
window w as (partition by 'Close Price' order by Date);

#Create a table tcs3 with signal logic
CREATE TABLE assignment.tcs3 
select Date,
case 
when `20 Day MA` > `50 Day MA` and
	  `Prev 20 Day MA` < `Prev 50 Day MA` then 'BUY'

when `20 Day MA` < `50 Day MA` and
	  `Prev 20 Day MA` > `Prev 50 Day MA` then 'SELL'
else 'HOLD'

end AS `Signal`
FROM tcs2;

#Join Signal column with tcs2 table
ALTER TABLE assignment.tcs2 ADD COLUMN `Signal` char(255);
UPDATE tcs2 LEFT JOIN tcs3 ON tcs2.Date = tcs3.Date
SET tcs2.Signal = tcs3.Signal;

#Dropping tcs3 tabble
drop table tcs3;

#Removing unnecessary columns from tcs2
ALTER TABLE tcs2 DROP column `20 Day MA`, DROP column `50 Day MA`, DROP column `Prev 20 Day MA`, DROP column `Prev 50 Day MA`;

##Create a table tvs2 with previous day MA column
CREATE TABLE assignment.tvs2 
select *,
lag(`20 Day MA`,1) over w as `Prev 20 Day MA`,
lag(`50 Day MA`,1) over w as `Prev 50 Day MA`
from tvs1
window w as (partition by 'Close Price' order by Date);

#Create a table tvs3 with signal logic
CREATE TABLE assignment.tvs3 
select Date,
case 
when `20 Day MA` > `50 Day MA` and
	  `Prev 20 Day MA` < `Prev 50 Day MA` then 'BUY'

when `20 Day MA` < `50 Day MA` and
	  `Prev 20 Day MA` > `Prev 50 Day MA` then 'SELL'
else 'HOLD'

end AS `Signal`
FROM tvs2;

#Join Signal column with tvs2 table
ALTER TABLE assignment.tvs2 ADD COLUMN `Signal` char(255);
UPDATE tvs2 LEFT JOIN tvs3 ON tvs2.Date = tvs3.Date
SET tvs2.Signal = tvs3.Signal;

#Dropping tvs3 tabble
drop table tvs3;

#Removing unnecessary columns from tvs2
ALTER TABLE tvs2 DROP column `20 Day MA`, DROP column `50 Day MA`, DROP column `Prev 20 Day MA`, DROP column `Prev 50 Day MA`;


####Task 4 creating a user defined function
DELIMITER $$ 
CREATE FUNCTION `stock_signal` (`Date` datetime) 
  RETURNS char(255)
  deterministic
BEGIN 
  DECLARE Signalvar char(255);
SELECT `Signal` INTO Signalvar
  FROM bajaj2
  WHERE `Date` = `Date`;
RETURN Signalvar;
END
$$
DELIMITER ;



