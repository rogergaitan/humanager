class Empagropecuaria < ActiveRecord::Base
  set_table_name 'EMPAGROPECUARIA'
  establish_connection :firebird
  
  belongs_to :empmaestcc, :foreign_key => :iemp
end
