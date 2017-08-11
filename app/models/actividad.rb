class Actividad < ActiveRecord::Base
  establish_connection :firebird
  self.table_name = 'actividades'
  
  belongs_to :task, foreign_key: :iactividad
end
