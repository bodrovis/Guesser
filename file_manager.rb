module FileManager
  class Writer
    attr_accessor :name

    def initialize(suffix)
      @name = generate_file_name(suffix)
    end

    def write(*args)
      file = File.new(@name, 'w+')
      file.write(args.join)
      file.close
    end

    private

    def generate_file_name(suffix)
      suffix + Time.now.hash.to_s + '.txt'
    end
  end
end