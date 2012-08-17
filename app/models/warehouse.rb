class Warehouse < ActiveRecord::Base
  attr_accessible :address, :code, :description, :manager, :name
end
