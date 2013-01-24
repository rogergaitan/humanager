class Cntpuc < ActiveRecord::Base
	set_table_name 'CNTPUC'
	establish_connection :firebird
	attr_accessible :icuenta, :ipadre, :ncuenta
end