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
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :encrypted_password, :password_confirmation, :remember_me, :username, :name
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

end
