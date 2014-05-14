class Until
  
  def self.log(info)
    STDOUT.puts "log:" + green(info)
  end

  def self.error(info)
    STDOUT.puts "error:" + red(info)
  end

  protected
    def self.colorize(color_code,str)
      "\e[#{color_code}m#{str}\e[0m"
    end

    def self.red(str)
      colorize(31,str)
    end

    def self.green(str)
      colorize(32,str)
    end

    def self.yellow(str)
      colorize(33,str)
    end

    def self.pink(str)
      colorize(35)
    end
end