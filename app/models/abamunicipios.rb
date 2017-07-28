class Abamunicipios < ActiveRecord::Base
  establish_connection :firebird
  
  belongs_to :abanit, foreign_key: :ipais
end
