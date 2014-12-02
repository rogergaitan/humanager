class CostsCenter < ActiveRecord::Base
  
  has_many :other_payments
  has_many :departments
  has_many :payroll_logs
  attr_accessible :icc_father, :icost_center, :icompany, :name_cc
  has_many :work_benefits

  before_destroy :confirm_presence_of_children
  before_update :confirm_is_not_parent
  protected
  
  def confirm_presence_of_children
    @icost_center = CostsCenter.find("#{id}")
    unless CostsCenter.where("icc_father = ?", @icost_center.icost_center).empty?
      errors.add(:base, "El elemento que esta intentando eliminar tiene hijos asociados")
      false
    end
  end
  
  def confirm_is_not_parent
    
  end

end
