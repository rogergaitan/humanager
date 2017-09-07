class Abamtdsop < ActiveRecord::Base
  self.table = "Abamtdsop"
  establish_connection "firebird"
end
