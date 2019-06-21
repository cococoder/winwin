require "winwin/version"
require "negotiation"
require 'uri'
require 'net/http'

module Winwin
  module HttpMethods 
    def connect(host:,path:)
        url = URI("#{host}/#{path}")
        http = Net::HTTP.new(url.host, url.port)
        yield url,http
    end
    def build_request(method:,url:,body:nil)
        request = nil
        case method
            when :put 
                request =  Net::HTTP::Put.new(url)
            when :post
                request = Net::HTTP::Post.new(url)
            when :get
                request = Net::HTTP::Get.new(url)
            else
              raise "Opooops ! unkown method!"
        end
        request["raiiar-tag"] = 'raiiar'
        request["raiiar-token"] = 'r4114r'
        request["content-type"] = 'application/x-www-form-urlencoded'
        request.body = body if body
        request
    end
    def build_response(http,request)
        http.request(request)
    end
    def as_json(response)
      JSON.parse(response.read_body)
    end
  end

  class Api
    def initialize
      @execution_stratergies = {
        local: LocalExecution, 
        remote: RemoteExecution
      }
    end

    class LocalExecution
      def execute(maximum:,minimum:)
        result = Result.new


        raise "here!"
      end
    end
    class RemoteExecution
      include HttpMethods
      def execute(maximum:,minimum:)
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
      @execution_stratergies[stratergy].new.execute(maximum: @maximum,minimum:@minimum)
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
