class DocumentNumber < ActiveRecord::Base
  belongs_to :company
  attr_accessible :description, :document_type, :mask, :number_type, 
  	:start_number, :terminal_restriction, :company_id

  validates :start_number, :presence => true
  validates :document_type, :uniqueness => true

end
