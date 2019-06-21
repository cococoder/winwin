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
    end
  end

end
