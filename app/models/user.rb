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

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :encrypted_password, :password_confirmation, :remember_me, 
    :username, :name, :company_id
  
  validates :name, :presence => true
  
  validates :username, :presence => true, :length => { :within => 4..10 }

  validates :email, :presence => true, :uniqueness => true

  def self.randow_string
    value = ''
    8.times { value << (65 + rand(25)).chr }
    return value
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

  # Sync users
  def self.sync_fb
    
    created_records = 0
    updated_records = 0
    usersfb = Abausuario.find(:all, :select => ['nusr', 'snombre', 'sapellido', 'semail'])

    usersfb.each do |ufb|
	      
      if User.where("username = ?", ufb.nusr).empty?

        numer = randow_string()
        new_user = User.new( :username => "#{ufb.nusr}",
                             :name => "#{ufb.snombre} #{ufb.sapellido}", 
	                           :email => "#{ufb.semail}", 
	                           :password => numer, 
	                           :password_confirmation => numer )

        if new_user.save
	        # Create default Permissions
	        PermissionsSubcategory.all.each do |sub|
            a = PermissionsUser.new(:permissions_subcategory_id => sub.id,
                                    :user_id => new_user.id,
                                    :p_create => false,
                                    :p_view => false,
                                    :p_modify => false,
                                    :p_delete => false,
                                    :p_close => false,
                                    :p_accounts => false,
                                    :p_pdf => false,
                                    :p_exel => false )
            a.save
          end
	        created_records += 1
        else
          new_user.errors.each do |error|
            Rails.logger.error "Error Creating User: #{ufb.nusr}, Description: #{error}"
          end
        end
      else
        update_user = User.find_by_username(ufb.nusr)
        params = {
          :name => "#{ufb.snombre} #{ufb.sapellido}",
          :email => "#{ufb.semail}"
        }
        updated_records += 1 if update_user.update_attributes(params)
      end
    end

    users_fb = {}
    users_fb[:notice] = ["#{I18n.t('helpers.titles.tasksfb')}: #{created_records} 
                          #{I18n.t('helpers.titles.tasksfb_update')}: #{updated_records}"]
    return users_fb
  end

end 
