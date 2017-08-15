class Task < ActiveRecord::Base

	has_many :payroll_logs
  belongs_to :currency
 	attr_accessible  :iactivity, :itask, :ntask, :nunidad, :currency_id, :cost, :nactivity

 	def self.search(search_activity, search_code, search_desc, currency, page)
    query = Task.includes(:currency)
    query = Task.where("nactivity LIKE ?", "#{search_activity}%") unless search_activity.empty?
    query = Task.where("itask LIKE ?", "#{search_code}%") unless search_code.empty?
    query = Task.where("ntask LIKE ?", "#{search_desc}%") unless search_desc.empty?
    query  = Task.where(currency_id: currency) unless currency.empty?
      
    query.paginate(:page => page, :per_page => 10)
	end
end
