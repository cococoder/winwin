require "winwin/version"
require "negotiation"

module Winwin
  class Error < StandardError; end
  
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :api_url, :token,:tag

    def initialize
      @api_url = 'http://raiiar.com/api'
      @token = "r4114r"
      @tag = "raiiar"
    end
  end# Your code goes here...
end
