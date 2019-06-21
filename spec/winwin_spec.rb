require 'uri'
require 'net/http'
require 'json'


RSpec.describe Winwin do
 describe "Configuration" do
    it 'should know the apir url' do

      api_url = "http://raiiar.com/api"

      Winwin.configure do |config|
        expect(api_url).to eq(config.api_url)
      end

    end
    it 'should know token' do

      token = "r4114r"

      Winwin.configure do |config|
        expect(token).to eq(config.token)
      end

    end
    it 'should know the tag' do

      tag = "raiiar"

      Winwin.configure do |config|
        expect(tag).to eq(config.tag)
      end

    end

  end

  describe "Negotiation" do
    it "should know when ok" do
      negotiation = Negotiation.new 
      expect(true).to eq negotiation.ok?
    end

    it "should know when ko" do
      negotiation = Negotiation.new 
      negotiation.ko!
      expect(false).to eq negotiation.ok?
    end

    it "should know the deal price" do
      negotiation = Negotiation.new
      negotiation.deal_price = 10.00
      expect(10.00).to eq negotiation.deal_price
    end
    it "should know the margin" do
      negotiation = Negotiation.new
      negotiation.margin = 10.00
      expect(10.00).to eq negotiation.margin
    end
  end

  describe "WinWin#Negotatiate" do

    it "should return a negotation" do
      negotiation = Winwin.negotiate(maximum: 10.00, minimum: 20.00) 
      expect(negotiation).not_to be_nil
    end
    it "should return a negotation" do
        api = Winwin::Api.new
        result = Object.new

        expect(result).to receive(:ok?) {true}
        expect(result).to receive(:deal_price) {15.00}
        expect(result).to receive(:margin) {10.00}

        expect(api).to receive(:start) { api}
        expect(api).to receive(:maximum).with(20.00) { api}
        expect(api).to receive(:minimum).with(10.00)  { api}

        expect(api).to receive(:execute) { result }
      negotiation = Winwin.negotiate(maximum: 20.00, minimum: 10.00,api: api) 
      expect(negotiation.ok?).to eq(true)
    end

    context "Api" do
      it "should call start on the api" do
        api = Winwin::Api.new
        result = Object.new

        expect(result).to receive(:ok?) {true}
        expect(result).to receive(:deal_price) {15.00}
        expect(result).to receive(:margin) {10.00}

        expect(api).to receive(:start) { api}
        expect(api).to receive(:maximum).with(20.00) { api}
        expect(api).to receive(:minimum).with(10.00)  { api}
        expect(api).to receive(:execute) { result }

        negotiation = Winwin.negotiate(maximum: 20.00,minimum: 10.00,api: api) 
        expect(negotiation.ok?).to eq(true)
        
      end
    end

    describe "Api::Local" do
      context "Result" do
        it "should know when is ok" do
           result  = Winwin::Api::Result.new
           result.ok!
           expect(result.ok?).to be_truthy
        end
      end
      context "Api:Execution" do
        xit "should calculate the deal price" do
          api = Winwin::Api.new
        
          result = api.start
           .maximum(20.00)
           .minimum(10.00)
           .execute(stratergy: :local)

           expect(result.ok?).to be_truthy
           expect(result.deal_price).to eq(15.00)
           expect(result.margin).to eq(10.00)
        end
      end
    end

    describe "Api::RemoteExecution" do
      let(:host) { "http://localhost:3000" } 
      it "should connect to api" do
        VCR.use_cassette("ok") do
          connect(host: host,path: "negotiations") do |url,http|
            request = build_request(method: :get,url: url)
            response = build_response(http,request)
            expect(response.code).to eq("200")
          end
  
        end
      end
      it "should connect to api ane get back a 500 error" do
        VCR.use_cassette("ko") do
          connect(host: host,path: "negotiations") do |url,http|
            request = build_request(method: :get,url: url)
            response = build_response(http,request)
            expect(response.code).to eq("500")
          end
        end
      end

      it "should get deal price" do
        VCR.use_cassette("deal_ok") do
          url = URI("http://localhost:3000/negotiations")

          http = Net::HTTP.new(url.host, url.port)

          request = Net::HTTP::Post.new(url)
          request["raiiar-tag"] = 'raiiar'
          request["raiiar-token"] = 'r4114r'
          request["content-type"] = 'application/x-www-form-urlencoded'
          request.body = "negotiation%5Buid%5D=deal_ok"

          response = http.request(request)
          data = JSON.parse(response.read_body)
          
        end
      end

        
    end
  end

end
