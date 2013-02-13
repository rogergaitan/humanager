module CheckDocumentNumber 
	###Providing a document type return true if it found an auto increment
	###option, otherwise nil.
	def self.check_number(document_type)
		@increment = DocumentNumber.find_by_document_type(document_type)
		@increment.number_type.eql? :auto_increment if @increment
	end

	###Giving a document type returns the next number to use if increment auto is true
	def self.next_number(document_type)
		@increment = DocumentNumber.find_by_document_type(document_type)
		puts @increment.start_number
		@increment.start_number + 1 if @increment
	end

	# def self.increment(document_type)
	# 	@increment = DocumentNumber.find_by_document_type(document_type)
	# end

end