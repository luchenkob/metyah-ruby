module ApplicationHelper
  def active_navigation?(controllers_name, actions_name = nil)
    if controllers_name.include?(controller_name)
      if actions_name.nil? || actions_name.include?(action_name)
        'active'
      end
    end
  end
end
