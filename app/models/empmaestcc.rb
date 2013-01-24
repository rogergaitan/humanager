class Empmaestcc < ActiveRecord::Base
  set_table_name 'EMPMAESTCC'
  establish_connection :firebird
  attr_accessible :iemp, :icc, :ncc, :iccpadre
end
