class DocumentNumber < ActiveRecord::Base
  belongs_to :company
  attr_accessible :description, :document_type, :mask, :number_type,
    :start_number, :terminal_restriction, :company_id

  validates :start_number, :presence => true
  validates :document_type, :uniqueness => true

  def self.check_number(document_type)
    @increment = find_by_document_type(document_type)
    @increment.number_type.eql? :auto_increment if @increment
  end

  def self.next_number(document_type)
    @increment = find_by_document_type(document_type)
    if @increment and @increment.number_type.eql? :auto_increment
      @increment.start_number + 1 
    end
  end

  private

  def self.increment_document_number(document_type)
    @increment = find_by_document_type(document_type)
    if @increment and @increment.number_type.eql? :auto_increment
      Rails.logger.debug "@increment.start_number #{@increment.start_number}"
      @increment.start_number += 1
      @increment.save!
    end
  end
end
