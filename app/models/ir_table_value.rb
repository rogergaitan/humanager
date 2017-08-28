class IrTableValue < ActiveRecord::Base
  attr_accessible :base, :excess, :from, :percent, :until
  
  belongs_to :ir_table
  
  validates_numericality_of :percent, :excess, :base, :from, :until, message: "valores deben ser numericos"
  validates_numericality_of :from, :until, greater_than: 0, message: "valor no puede ser menor que 0"
end
