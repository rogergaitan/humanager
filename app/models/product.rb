# == Schema Information
#
# Table name: products
#
#  id           :integer          not null, primary key
#  code         :string(255)
#  line_id      :integer
#  subline_id   :integer
#  category_id  :integer
#  part_number  :string(255)
#  name         :string(255)
#  make         :string(255)
#  model        :string(255)
#  year         :string(255)
#  version      :string(255)
#  max_discount :integer
#  address      :string(255)
#  max_cant     :integer
#  min_cant     :integer
#  cost         :float
#  bar_code     :string(255)
#  market_price :integer
#  status       :enum([:active, :
#  stock        :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Product < ActiveRecord::Base

  #ASSOCIATIONS
  belongs_to :subline
  belongs_to :line
  belongs_to :category
  has_many :product_applications, :dependent => :destroy

  ##ATTRIBUTES
  attr_accessible	:address, :bar_code, :category_id,
    :code, :cost, :line_id, :make, :market_price, :max_cant,
    :max_discount, :min_cant, :model, :name, :part_number,
    :status, :stock, :subline_id, :version, :year, :product_aplications_attributes

  #VALIDATIONS
  validates :code,
    :length => { :within => 4..10 },
    :uniqueness => { :case_sensitive => false }

  validates :code, :line_id, :subline_id, :category_id, :part_number, :name,
    :presence => true

  ##GENERAL SEARCH
  def self.search(search)
    query = ""
    if search
      search = search.split() if search.class != Array

      if search
        data = []
        search.each do |q|
          data.push(" name like '%#{q.strip}%'") if q and q.length >= 3
        end
      end
    query = build_query(data)
    where(query) if query
    end
  end

  #ADVANCE SEARCH
  def self.advance_search(applications, code, name, part_number)
    query = ""
    params = []
    params.push(" products.code LIKE '%#{code}%' ") if code and code.length >= 3
    params.push(" products.name LIKE '%#{name}%' ") if name and name.length >= 3
    params.push(" products.part_number LIKE '%#{part_number}%' ") if part_number and part_number.length >= 3
    params.push(" product_applications.name LIKE '%#{applications}%' ") if applications and applications.length >= 3
    query = build_query(params)
    if applications
      includes(:product_applications).where(query)
    else
      where(query) if query
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

  def self.set_cart(cart_products)
    Rails.cache.write("Product.cart", cart_products )
  end

  def self.get_cart
    Rails.cache.fetch("Product.cart")
  end

  def self.clean_cache
    Rails.cache.delete("Product.cart")
  end

end
