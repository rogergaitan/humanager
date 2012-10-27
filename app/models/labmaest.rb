# -*- encoding : utf-8 -*-
class Labmaest < ActiveRecord::Base
	set_table_name 'LABMAEST'
	establish_connection :firebird
  	attr_accessible :iactividad, :ilabor, :nlabor, :icuenta, :mcostolabor

end
