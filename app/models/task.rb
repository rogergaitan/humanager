class Task < ActiveRecord::Base

	has_many :payroll_logs
 	attr_accessible  :iaccount, :iactivity, :itask, :mlaborcost, :ntask, :nunidad

 	def self.search(search_code, search_desc, page, per_page = nil)
	    query = ""
	    params = []
	    params.push(" tasks.itask like '%#{search_code}%' ") unless search_code.empty?
	    params.push(" tasks.ntask like '%#{search_desc}%' ") unless search_desc.empty?
	    query = build_query(params)
	    
	    if(query != "")
	    	Task.where(query).paginate(:page => page, :per_page => 15)
	    else
	    	Task.paginate(:page => page, :per_page => 15)
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
		query
	end

end