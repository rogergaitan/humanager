class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
    list = {}
    PermissionSubcategory.all.each do |subcategory|
        list[subcategory.name] = subcategory.id
    end
    
    user ||= User.new
    ######################################################################################
    # PROVINCES
    ######################################################################################
    province = user.permissions_user.find_by_permissions_subcategory_id(list['Provincias'])
    if province.p_create
        can :create Province
    end

    if province.p_view
        can :read Province
    end

    if province.p_modify
        can :update Province
    end

    if province.p_delete
        can :destroy Province
    end
    ######################################################################################
    # CANTONS
    ######################################################################################
    canton = user.permissions_user.find_by_permissions_subcategory_id(list['Cantones'])
    if canton.p_create
        can :create Canton
    end

    if canton.p_view
        can :read Canton
    end

    if canton.p_modify
        can :update Canton
    end

    if canton.p_delete
        can :destroy Canton
    end
    ######################################################################################
    # DISTRICTS
    ######################################################################################
    district = user.permissions_user.find_by_permissions_subcategory_id(list['Distritos'])
    if district.p_create
        can :create District
    end

    if district.p_view
        can :read District
    end

    if district.p_modify
        can :update District
    end

    if district.p_delete
        can :destroy District
    end
    ######################################################################################
    # 
    ######################################################################################
  end
end
