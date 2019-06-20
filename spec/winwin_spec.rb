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
end
