# == Schema Information
#
# Table name: employees
#
#  id                   :integer          not null, primary key
#  entity_id            :integer
#  gender               :enum([:male, :fe
#  birthday             :date
#  marital_status       :enum([:single, :
#  number_of_dependents :integer
#  spouse               :string(255)
#  join_date            :date
#  social_insurance     :string(255)
#  ccss_calculated      :boolean
#  department_id        :integer
#  occupation_id        :integer
#  role_id              :integer
#  seller               :boolean
#  payment_method_id    :integer
#  payment_frequency_id :integer
#  means_of_payment_id  :integer
#  wage_payment         :decimal(12, 2)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class Employee < ActiveRecord::Base
  has_one :department
  belongs_to :entity, :dependent => :destroy
  belongs_to :department
  belongs_to :occupation
  belongs_to :role
  belongs_to :payment_method
  belongs_to :payment_frequency
  belongs_to :means_of_payment
  attr_accessible :gender, :birthday, :marital_status, :ccss_calculated, :join_date, 
  					:number_of_dependents, :seller, :social_insurance, :spouse, 
  					:wage_payment, :entity_attributes, :department_id, 
  					:occupation_id, :role_id, :payment_method_id, :payment_frequency_id,
  					:means_of_payment_id
  accepts_nested_attributes_for :entity, :allow_destroy => true

  def full_name
    "#{entity.name} #{entity.surname}"
  end
end
