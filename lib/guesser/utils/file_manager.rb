module Guesser
  module FileManager
    class Writer
      attr_accessor :name

      def initialize(suffix)
        @name = generate_file_name(suffix)
      end

      def <<(*args)
        file = File.new(name, 'w+')
        begin
          file.write(args.join)
        rescue StandardError => e
          warn e.message
        ensure
          file.close
        end
      end

      private

      def generate_file_name(suffix)
        suffix + Time.now.hash.to_s + '.txt'
      end
    end
  end
end