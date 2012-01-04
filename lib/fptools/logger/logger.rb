require 'logger'

module Fptools
  class Logger
    LOG_DIR = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'log'))
    LOG_FILE = File.join(LOG_DIR, 'fptools.log')
    FileUtils.mkdir_p(LOG_DIR)

    LOGGER = ::Logger.new(LOG_FILE)

    class << self
      [:debug, :warn, :info, :error, :fatal].each do |x|
        define_method x do |args|
          LOGGER.send(x, args)
        end
      end

    end
  end

  Logger.info("--- Started logging at #{Time.now} ---")
end
