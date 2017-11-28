class IrTable < ActiveRecord::Base
  attr_accessible :end_date, :name, :start_date, :ir_table_values_attributes
  
  has_many :ir_table_values, dependent: :destroy, inverse_of: :ir_table
  
  accepts_nested_attributes_for :ir_table_values, allow_destroy: true
  
  validates :name, :start_date, :end_date, presence: true
  validates_uniqueness_of :name, case_sensitive: false
  
  validate :start_date_end_date
  validate :from_value_cannot_be_greater
  validate :date_range_uniqueness
  
  def start_date_end_date
    unless start_date.blank? || end_date.blank?
      if start_date > end_date
        errors.add :start_date, "Fecha desde no puede ser despues de Fecha hasta."
      end
    end
  end
  
  def from_value_cannot_be_greater
    ir_table_values.each_with_index do |ir_table_value, index|
      unless index == 0
        unless ir_table_value.from.blank? || ir_table_values[index -1].until.blank?
          if ir_table_value.from <= ir_table_values[index -1].until
           errors.add :base, "Valor del campo De debe ser al menos un numero mayor que el campo Hasta del estrato anterior."
         end
        end
      end
    end
  end
  
  def date_range_uniqueness
    unless start_date.blank? || end_date.blank?
      if persisted?
        if IrTable.where("start_date BETWEEN :start_date AND :end_date OR end_date BETWEEN :start_date AND :end_date", 
                                  start_date: start_date, end_date: end_date).where("id NOT IN(?)", id).any?
          error = true
        end
      else
        if IrTable.where("start_date BETWEEN :start_date AND :end_date OR end_date BETWEEN :start_date AND :end_date",
                                  start_date: start_date, end_date: end_date).any?
          error = true
        end
      end
      errors.add :base, "Debe introducir un rango de fechas que no coincida con un registro existente." if error
    end
  end
  
  def self.validate_name_uniqueness(id, name)
    if id.blank?
      ir_table = IrTable.new name: name
    else
      ir_table = IrTable.find id
      ir_table.name = name
    end
    
    ir_table.valid?
    
    if ir_table.errors[:name].any?
      status = 404
    else
      status = 200
    end  
  end
  
end
