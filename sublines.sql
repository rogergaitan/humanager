SET SQL_SAFE_UPDATES=0; 
/**Insert csv Skills**/
Delete FROM reasapp_development.sublines;

LOAD DATA INFILE "/usr/share/mysql/sublines.csv" 
INTO TABLE reasapp_development.sublines FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\n' IGNORE 1 LINES (@COD_SUBLINEA,@NOMBRE) SET code = @COD_SUBLINEA, name = @NOMBRE;