module CloudApp
  
  # An ActiveResource-like interface through which to interract with CloudApp gift cards.
  #
  #
  # @example Gets started by Authenticating
  #   CloudApp.authenticate "username", "password"
  #
  # @example Usage via the GiftCard class
  #   # View gift card details
  #   @gift = CloudApp::GiftCard.find "ABC123"
  #   
  #   # Apply the gift card
  #   CloudApp::GiftCard.redeem "ABC123"
  #     # or
  #   @gift.redeem
  # 
  class GiftCard < Base
    
    # Get the details of an unredeemed gift card.
    #
    # Requires authentication.
    #
    # @param [String] code Gift card code
    # @return [CloudApp::GiftCard]
    def self.find(code)
      res = get "/gift_cards/#{code}", :digest_auth => @@auth
      res.ok? ? GiftCard.new(res) : res
    end
    
    # Apply a gift card to the authenticated account.
    #
    # Requires authentication.
    #
    # @param [String] code Gift card code
    # @return [CloudApp::GiftCard]
    def self.redeem(code)
      res = put "/gift_cards/#{code}", {:body => {}, :digest_auth => @@auth}
      res.ok? ? GiftCard.new(res) : res
    end
    
    attr_reader :id, :code, :plan, :months, :href,
                :created_at, :updated_at, :redeemed_at, :effective_at, :expires_at
    
    # Create a new CloudApp::GiftCard object.
    #
    # Only used internally
    #
    # @param [Hash] attributes
    # @param [CloudApp::GiftCard]
    def initialize(attributes = {})
      load(attributes)
    end
    
    # Apply the gift card to the authenticated account.
    #
    # @return [CloudApp::GiftCard]
    def redeem
      self.class.redeem code
    end
    
  end
  
end