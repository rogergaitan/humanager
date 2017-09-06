# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class User < ActiveRecord::Base

  has_many :permissions_user, :dependent => :destroy
  belongs_to :company
  has_many :companies
  # after_create :create_permissions

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :encrypted_password, :password_confirmation, :remember_me, 
    :username, :name, :company_id
  # attr_accessible :title, :body

  validates :name,
			:presence => true
  
  validates :username,
  				:presence => true,
  				:length => { :within => 4..10 }

  validates :email,
  			:presence => true,
  			:uniqueness => true

  after_create :send_welcome_email

  def send_welcome_email
    
    puts "EMAIL CREATE USER"

    # #email_object: hash with the email queue attributes
    # #CONFIG is a hash constant that takes values from a configuration file (/config/application.yml)
    # email_object = { user_id: id, to: email,
    #   subject: CONFIG[:email_templates]['welcome']['subject'],
    #   from: 'humanager.mailer.test@gmail.com' }
    # #template_data: Hash for passing data to the email template
    # template_data = { first_name: first_name, email: email }
    # EmailQueue.save_email(email_object, CONFIG[:email_templates]['welcome']['template'], template_data)
  end

  def self.search_users(username, name, actualuser, page, per_page)
    query = User.includes :permissions_user
    query = query.where("username LIKE ?", "%#{username}%") unless username.empty?
    query = query.where("name LIKE ?", "%#{name}%") unless name.empty?
    unless name.empty? && username.empty?
      query = query.where("id <> ?", "#{actualuser}") unless actualuser.empty? 
      query.paginate :page => page, :per_page => per_page
    else
      User.limit 0
    end
  end

  def self.save_permissions_user(data, user_id)
    
    @result = true
    begin
      transaction do
        data.each do |c|
          PermissionsUser.find_by_user_id_and_permissions_subcategory_id(user_id, c[1]['id_subcategory'])
                          .update_attributes(
                              :p_create => c[1]['p_create'],
                              :p_view => c[1]['p_view'],
                              :p_modify => c[1]['p_modify'],
                              :p_delete => c[1]['p_delete'],
                              :p_close => c[1]['p_close'],
                              :p_accounts => c[1]['p_accounts'],
                              :p_pdf => c[1]['p_pdf'],
                              :p_exel => c[1]['p_exel']
                          )
          end # End
        end # End Transaction
    rescue Exception => exc
      @result = false
    end # End Begin
    
    @result
  end

  def self.get_permissions(id)
    @permissions = PermissionsUser.where('user_id=?', id)
  end

  # def create_permissions
  #   # self same to this
  #   logger.debug 'create_permissions after_create'
  #   logger.debug self.to_yaml
  # end

end
