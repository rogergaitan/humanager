SET SQL_SAFE_UPDATES=0; 
/**Insert csv Skills**/
Delete FROM products;

LOAD DATA INFILE "/usr/share/mysql/articulos.csv" 
INTO TABLE products FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES 
(@COD_ARTICULO,@COD_LINEA,@COD_SUBLINEA, @NOMBRE, @NUMERO_PARTE) 
SET code = @COD_ARTICULO, 
		line_id = @COD_LINEA, 
		subline_id = @COD_SUBLINEA, 
		name = @NOMBRE, 
		part_number = @NUMERO_PARTE;