class Machine
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  LINES_QUANTITY = 3
  
  attr_accessor :name, :reels, :result, :win

  def press_button
    self.result = []
    self.reels.each do |reel|
      # Generate random shift to move every reel
      shift = rand(0..reel.length-1)
      # Adding 3x5 array to result
      # 2 reels are concatenated becuase reel is a circle
      self.result << (reel+reel)[shift..shift+LINES_QUANTITY-1]
    end
    
    check_combinations
    check_custom_combinations
  end
  
  private
    def initialize(name)
      send("name=", name)

      set_default_name
      load_reels
    end
    
    def persisted?
      false
    end

    def set_default_name
      self.name ||= "default"
      self.name = "default" if SLOT_MACHINES[self.name].nil?
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
    
    def check_combinations
      return if self.result.empty?
      
      self.win = 0

      # Check default combinations
      combinations = SLOT_MACHINES[self.name]['combinations']['default']
      pass = []

      # Full line
      if combinations['full_line']['enabled']
        if x_in_line_combination? self.result.length
          self.win += combinations['full_line']['sum']
          pass << "in_line_4"
          pass << "in_line_3"          
        end
      end
      
      # 4 of 5 in line
      if combinations['in_line_4']['enabled'] && !pass.include?("in_line_4")
        if x_in_line_combination? 4
          self.win += combinations['in_line_4']['sum']
          pass << "in_line_3"
        end
      end
      
      # 3 of 5 in line
      if combinations['in_line_3']['enabled'] && !pass.include?("in_line_3")
        self.win += combinations['in_line_3']['sum'] if x_in_line_combination? 3
      end
    end
  
    def x_in_line_combination?(x)
      for i in 0..self.result[0].length-1
        for j in 0..self.result.length-x
          win = true
          last_icon = self.result[j][i][:name]
          for z in j..j+x-1
            win = false if last_icon != self.result[z][i][:name]
          end
          return true if win
        end
        return true if win
      end
      
      return false
    end
    
    def check_custom_combinations
      combinations = SLOT_MACHINES[self.name]['combinations']['custom']
      combinations.each do |combination|
        if combination[1]['line'].present?
          for i in 0..self.result[0].length-1
            win = true
            combination[1]['line'].each do |line|
              win = false if self.result[line[0].to_i-1][i][:name] != line[1]
            end
            self.win += combination[1]['sum'] if win
          end
        end
      end
    end
end