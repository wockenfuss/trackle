module ApplicationHelper

	def trackle_root(user)
    if !user || user.has_role?(:admin)
      return root_path
    else
      return user_path(user)
    end
  end
end
