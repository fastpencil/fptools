require 'drb'

module Fptools
  module Daemon
    def init
      puts "Starting Fptools Daemon."
      @setup = true
    end

    def setup?
      @setup
    end

    def start
      DRb.start_service 'druby://localhost:2250', ::Fptools::Service.new
      puts DRb.uri
      DRb.thread.join
    end

    def signal
      trap("INT") { DRb.stop_service }
    end

    def stop
    end

    extend self
  end
end

