class Asset < ActiveRecord::Base
  belongs_to :space

  # attachment_fu configuration
  # note: the slashes are to make rcov happy
  has_attachment :processor => Slate.config.assets.processor, \
    :thumbnails => {
      'sq' => 75,
      'tn' => '100x100>',
      'sm' => '240x240>',
      'md' => '500x500>',
      'lg' => '1024x1024>'      
    }, :storage => :file_system
    
  # Ensure that the site id is properly set for thumbnails  
  before_thumbnail_saved do |asset, thumbnail|
    thumbnail.space_id = asset.space_id
  end  
  
  include Slate::AttachmentFu

public
  # Returns name of this asset (defaulting to filename)
  def name
    super.blank? ? filename : super
  end
  
  # Opens the zip file and returns ZipEntry for each entry
  def entries
    return nil unless self.zip?
    Zip::ZipFile.open(self.full_filename) do |zip|
      zip.select do |e| 
        e.file? && e.name !~ /(^__MACOSX|\.DS_Store)/ 
      end
    end
  end
  
  # Extracts the ZIP file
  def extract!
    return nil unless self.zip?
    self.entries.map do |entry|
      tempfile = Tempfile.new('slate_asset')
      entry.extract(tempfile.path) { true }
      self.class.create(
        :uploaded_data => UploadedFile.new(tempfile, entry.name),
        :space_id => self.space_id)
    end 
  end
  
  def dimensions
    [width, height].join('x')
  end
  
  def thumbnail_name
    case thumbnail
    when nil, '' ; 'original'
    when 'sq'    ; 'square'
    when 'tn'    ; 'thumbnail'
    when 'sm'    ; 'small'  
    when 'md'    ; 'medium'  
    when 'lg'    ; 'large'  
    end
  end
  
  def available_thumbnails
    order = %w(sq tn sm md lg)
    thumbnails.sort_by { |e| order.index(e.thumbnail) }
  end
end