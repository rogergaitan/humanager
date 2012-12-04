class CentroDeCosto < ActiveRecord::Base
  
  has_many :departments
  has_many :payroll_logs
  attr_accessible :icc_padre, :icentro_costo, :iempresa, :nombre_cc
  


  before_destroy :confirm_presence_of_children
  before_update :confirm_is_not_parent
  protected
  
  def confirm_presence_of_children
    @icentro_costo = CentroDeCosto.find("#{id}")
    unless CentroDeCosto.where("icc_padre = ?", @icentro_costo.icentro_costo).empty?
      errors.add(:base, "El elemento que esta intentando eliminar tiene hijos asociados")
      false
    end
  end
  
  def confirm_is_not_parent
    
  end
end
