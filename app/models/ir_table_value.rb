class IrTableValue < ActiveRecord::Base
  attr_accessible :base, :excess, :from, :percent, :until
  
  belongs_to :ir_table

  validates_numericality_of :percent, :excess, :base, :from, :until, message: "valores deben ser numericos."
  validates_numericality_of :from, :until, greater_than_or_equal_to: 0, message: "valores no pueden ser menor que 0."
  
  validate :from_until_values
  
  def  from_until_values
    errors.add :from, "valor no puede ser mayor o igual al del campo Hasta." if self.from >= self.until
  end
  
end
