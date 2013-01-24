class Department < ActiveRecord::Base

  attr_accessible :name, :employee_id, :centro_de_costos_id

  belongs_to :employee
  belongs_to :centro_de_costos
  has_many :employees

  validates :name, :presence => true, :uniqueness => true
  validates :employee_id,:centro_de_costos_id,
    :presence => true

end
