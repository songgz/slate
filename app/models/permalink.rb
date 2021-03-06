class Permalink < ActiveRecord::Base
  named_scope :primary, :conditions => { :is_default => true }
  named_scope :with_type, lambda { |type| 
    { :conditions => { :permalinkable_type => type } }
  }
  
  belongs_to :permalinkable, :polymorphic => true
  
  validates_presence_of :name
  
  def to_s
    name
  end
end