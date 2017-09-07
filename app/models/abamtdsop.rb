class Abamtdsop < ActiveRecord::Base
  self.table_name = "ABAMTDSOP"
  establish_connection "firebird"
end
