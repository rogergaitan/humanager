# -*- encoding : utf-8 -*-
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Set data
payment_types = [
	{
		factor: 1.00,
		name: 'Ordinario',
		contract_code: '1',
		payment_type: 'ordinary',
		payment_unit: 'Ordinario',
		state: 'active'
	}, {
		factor: 1.50,
		name: 'Extra',
		contract_code: '2',
		payment_type: 'extra',
		payment_unit: 'Extra',
		state: 'active'
	}, {
		factor: 2.00,
		name: 'Doble',
		contract_code: '3',
		payment_type: 'double',
		payment_unit: 'Extra',
		state: 'active'
	}
]

# Set data for each company
if ENV['COMPANY_CODE']
	# Adding the new values
	payment_types.each do |attributes|
		p = PaymentType.new()
		p.factor = attributes[:factor]
		p.name = attributes[:name]
		p.contract_code = attributes[:contract_code]
		p.payment_type = attributes[:payment_type]
		p.payment_unit = attributes[:payment_unit]
		p.state = attributes[:state]
		p.company_id = ENV['COMPANY_CODE']
		p.save!
	end
end



# puts 'SETTING UP DEFAULT USER LOGIN'
# user = User.create! :username => 'admin', :name => 'Admin User', :email => 'admin@dotcreek.com', :password => 'password', :password_confirmation => 'password'
# puts 'New user created: ' << user.name

# puts "Creating Model Names"
# ModelName.create([
# 	{ name: Province.model_name },
# 	{ name: Canton.model_name },
# 	{ name: District.model_name },
# 	{ name: Employee.model_name },
# 	{ name: Department.model_name },
# 	{ name: Position.model_name },
# 	{ name: Deduction.model_name },
# 	{ name: WorkBenefit.model_name },
# 	{ name: Occupation.model_name },
# 	{ name: MeansOfPayment.model_name },
# 	{ name: PaymentFrequency.model_name },
# 	{ name: TypeOfPersonnelAction.model_name },
# 	{ name: PayrollType.model_name },
# 	{ name: User.model_name },
# 	{ name: PaymentType.model_name },
# 	{ name: OtherPayment.model_name },
# 	{ name: Payroll.model_name },
# 	{ name: PayrollLog.model_name },
# 	{ name: DetailPersonnelAction.model_name },
# 	{ name: Task.model_name }
# ])

# puts "Creating permisionss from SQL file in db/permissions.sql"

# sql = File.open("db/permissions.sql").read
# sql.split(';').each do |sql_statement|
#   ActiveRecord::Base.connection.execute(sql_statement)
# end

# puts "Completed, you can now login with admin/password"

