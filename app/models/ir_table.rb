class IrTable < ActiveRecord::Base
  attr_accessible :end_date, :name, :start_date, :ir_table_values_attributes
  
  has_many :ir_table_values, dependent: :destroy, inverse_of: :ir_table
  
  accepts_nested_attributes_for :ir_table_values, allow_destroy: true
  
  validates :name, :start_date, :end_date, presence: true
  validates :name, uniqueness: true
  
  validate :validate_ir_table_values
  
  def validate_ir_table_values
    error = false
    self.ir_table_values.each_with_index do |ir_table_value, index|
      
      unless index == 0
        unless ir_table_value.from.nil? || self.ir_table_values[index -1].until.nil?
          if ir_table_value.from <= self.ir_table_values[index -1].until
           error = true
         end
        end
      end
    end
    errors.add :base, "Valor del campo De debe ser al menos un numero mayor que el campo Hasta del estrato anterior"  if error
  end
  
end
