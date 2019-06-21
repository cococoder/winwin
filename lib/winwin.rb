require "winwin/version"
require "negotiation"

module Winwin
  class Api
    
    def initialize
      @execution_stratergies = {
        local: LocalExecution, 
        remote:RemoteExecution
      }
    end

    class LocalExecution
      def execute

        raise "here!"
      end
    end
    class RemoteExecution
      def execute
        result = Result.new
        
        api_url = Winwin.configuration.api_url
        token = Winwin.configuration.token
        tag = Winwin.configuration.tag

        result
      end
    end
    class Result
      attr_accessor :deal_price,:margin
      def initialize
        @result = false
      end
      def ok?
        @result
      end
      def ok!
        @result = true
      end
    end
    def start
      self
    end
    def minimum(value)
      @minimum = value
      self
    end 
    def maximum(value)
      @maximum = value 
      self
    end
    def execute(stratergy: :remote)
      @execution_stratergies[stratergy].new.execute
    end
  end
  class Error < StandardError; end
  
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  def self.negotiate minimum:, maximum:,api: Api.new
    result =  api.start
      .maximum(maximum) 
      .minimum(minimum)
      .execute

    negotiation = Negotiation.new

    if result.ok?
      negotiation.deal_price = result.deal_price
      negotiation.margin = result.margin
      negotiation.ok!
    else
      negotiation.ko!
    end


    negotiation 
  end

  class Configuration
    attr_accessor :api_url, :token,:tag

    def initialize
      @api_url = 'http://raiiar.com/api'
      @token = "r4114r"
      @tag = "raiiar"
    end
  end
  
end
