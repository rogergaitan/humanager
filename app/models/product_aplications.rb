class ProductAplications < ActiveRecord::Base
  belongs_to :product
  attr_accessible :description
end
