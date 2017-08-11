class Labtdcto < ActiveRecord::Base
  establish_connection 'firebird'
  self.table_name = 'labtdcto'
end
