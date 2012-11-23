SET SQL_SAFE_UPDATES=0; 
/**Insert csv Skills**/
Delete FROM reasapp_development.lines;

LOAD DATA INFILE "/usr/share/mysql/lines.csv" 
INTO TABLE reasapp_development.lines FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES 
(@COD_LINEA,@NOMBRE) 
SET code = @COD_LINEA, 
		name = @NOMBRE;