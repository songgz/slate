ActionController::Routing::Routes.draw do |map|
  # public side
  # map all requests that do not have slate as the subdomain to
  # the public controller and group all parameters in page_path
  map.connect '*page_path', :controller => 'public', :conditions => { 
    :not_subdomain => 'slate' }

  map.default '', :controller => 'account', :action => 'login', 
    :erp => '/account/login'

  map.connect 'stylesheets/:action.:format', :controller => 'stylesheets'
  
  # ==========================================
  # mappings for accounts
  # ==========================================
  map.resource :account, :controller => 'account', 
    :member => { :login => :any, :logout => :get }
  
  # custom routes for verify and approve because they
  # require certain parameters
  map.with_options :controller => 'account' do |m|
    m.verify_account 'account/verify/:id/:key', :action => 'verify'
    m.approve_account 'account/approve/:id/:key', :action => 'approve'
    
    m.login 'login', :action => 'login', :erp => '/account/login'
    m.logout 'logout', :action => 'logout', :erp => '/account/logout'
  end

  map.resources :users

  # ==========================================
  # mappings for spaces
  # ==========================================
  map.resources :spaces, :collection => { :choose => :post } do |space|
    space.resource :dashboard, :controller => 'dashboard',
      :name_prefix => 'space_'
    space.resources :pages do |page|
      page.resources :areas, :member => { 
        :toggle => :any, 
        :preview => :post,
        :version => :get
      }
    end
    
    space.resources :assets, :member => {
      :extract => :get
    }
  end
  
  # custom route for new page which allows an id to be
  # passed in - this is considered the parent id
  map.new_space_page 'spaces/:space_id/pages/new/:id', 
    :controller => 'pages', :action => 'new'
  
  map.resource :dashboard, :controller => 'dashboard'
  
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end