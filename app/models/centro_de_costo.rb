# == Schema Information
#
# Table name: centro_de_costos
#
#  id            :integer          not null, primary key
#  iempresa      :string(255)
#  icentro_costo :string(255)
#  nombre_cc     :string(255)
#  icc_padre     :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

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
