class Empmaestcc < ActiveRecord::Base
  set_table_name 'EMPMAESTCC'
  establish_connection :firebird
  attr_accessible :iemp, :icc, :ncc, :iccpadre, :inivel
  
  has_one :empagropecuaria, :foreign_key => :iemp
end
