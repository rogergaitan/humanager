class Abanitsddirecciones < ActiveRecord::Base
  establish_connection :firebird
  
  belongs_to :abanit, foreign_key: :init
end
