class Task < ActiveRecord::Base

	has_many :payroll_logs
  belongs_to :currency
 	attr_accessible  :iactivity, :itask, :ntask, :nunidad, :currency_id, :cost, :nactivity

 	def self.search(search_activity, search_code, search_desc, page)
	    query = ""
	    params = []
      params.push("tasks.nactivity like '%#{search_activity}%'") unless search_activity.empty?
	    params.push(" tasks.itask like '%#{search_code}%' ") unless search_code.empty?
	    params.push(" tasks.ntask like '%#{search_desc}%' ") unless search_desc.empty?
	    query = build_query(params)
	    
	    if(query != "")
	    	Task.where(query).paginate(:page => page, :per_page => 10)
	    else
	    	Task.paginate(:page => page, :per_page => 10)
	    end
	end

	def self.build_query(data)
		query = ""
		if data
		  data.each_with_index do |q, i|
		    if i < data.length - 1
		      query += q + " AND "
		    else
		      query += q
		    end
		  end
		end
		query.includes(:currency)
	end
  
  def self.find_by_currency(currency_id)
    where currency_id: currency_id
  end

end
