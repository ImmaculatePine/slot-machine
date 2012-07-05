class Machine
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  attr_accessor :name, :reels

  private
    def initialize(attributes = {})
      attributes.each do |name, value|
        send("#{name}=", value)
      end

      set_default_name
      load_reels
    end
    
    def persisted?
      false
    end

    def set_default_name
      self.name ||= "default"
    end
  
    def load_reels
      self.reels = []
      SLOT_MACHINES[self.name]["reels"].each do |reel|
        reel = reel.to_a[1]
        new_reel = []
        reel.each do |icon|
          icon_name = icon.to_a[1]
          new_reel << {name: icon_name , image: SLOT_MACHINES[self.name]["icons"][icon_name]}
        end
        self.reels << new_reel
      end
    end
end