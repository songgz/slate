class StylesheetsController < ApplicationController
  # disable sessions
  session :off
  
  # don't try to load a user for CSS files
  skip_before_filter :capture_user!

  # renders and caches the stylesheet
  around_filter :render_stylesheet
  
  # CSS files don't have layouts
  layout nil

private
  # around filter which takes care of setting up 
  # headers for rendering, then performs the actual
  # render and finally caches the result
  def render_stylesheet
    self.class.page_cache_directory = Rails.public_path

    # set the content type for stylesheets
    headers['type'] = 'text/css; charset=utf-8'
    
    # perform the action
    yield
    
    # cache the result
    cache_page nil, request.path
  end  
end