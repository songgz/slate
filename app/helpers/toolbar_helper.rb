module ToolbarHelper
  # returns a collectible for toolbars
  def toolbar_collection
    @toolbar_collection ||= Slate::Collectible.new(:toolbar)
  end
  
  # creates a new collectible item
  def toolbar_item(key=nil, content=nil, &block)
    toolbar_collection.push(key, content, &block)
  end
  
  # renders collectible
  def toolbar(*args)
    options = Hash === args.last ? args.pop : {}
        key = args.first unless Hash === args.first
    
    items = toolbar_collection.items(key).reject(&:blank?)

    options.reverse_merge!({ 
      :separator => '|', 
      :separator_options => { :class => 'separator' },
      :class => 'toolbar'
    })

    separator = options.delete(:separator)
    separator_options = options.delete(:separator_options)

    unless items.empty?
      separator = content_tag('li', separator, separator_options)
      list_items = items.map { |e| content_tag('li', e) }.join(separator)
      content_tag('ul', list_items, options)
    end
  end
end