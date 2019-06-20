class Negotiation
   attr_accessor :deal_price, :margin 
   def initialize
     ok!
   end

   def ok?
     @ok
   end

   def ok!
     @ok = true
   end

   def ko!
     @ok = false
   end
 end

