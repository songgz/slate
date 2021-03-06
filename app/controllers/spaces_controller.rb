class SpacesController < ResourcesController
  resources_controller_for :spaces
  current_tab 'Settings'
  
  before_filter :ensure_super_user!, :only => [:new]

protected
  def resource_service
    if User.active.super_user? || %w(new create).include?(action_name)
      Space
    else  
      User.active.spaces
    end  
  end

  # finds the given space and makes it active
  def find_resource
    Space.active = self.resource = 
      resource_service.find(params[:id])
    
    # TODO - ensure membership or super user here
    # to prevent random people from modifying another
    # site
  end
  
public
  # Returns resource name for this resource
  # We're using _space here because 'space' is 
  # used by the nested resources and points to the
  # active space
  def resource_name
    '_space'
  end

  # redirects to dashboard for space indicated by
  # space_id parameter -- this action is used by the 
  # space chooser form
  def choose
    redirect_to space_dashboard_url(params[:space_id])  
  end
  
  # redirect to the dashboard for given space
  # on GET to /show/:id
  def show
    redirect_to space_dashboard_url(params[:id])
  end
end