require 'test_helper'

class UniversalHelperTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Integrations

  def setup
    @order = 'order-500'
    @account = 'zork@example.com'
    @amount = 123
    @amount_shipping = 45
    @amount_tax = 6
    @currency = 'USD'
    @key = 'zork'
    @helper = Universal::Helper.new(@order, @account, :amount => @amount, :currency => @currency, :credential2 => @key)
  end

  def test_basic_helper_fields
    assert_field 'x-id', @account
    assert_field 'x-currency', @currency
    assert_field 'x-amount', @amount
    assert_field 'x-reference', @order

  end

  def test_customer_fields
    @helper.customer :first_name => 'Cody', :last_name => 'Fauser', :email => 'cody@example.com'
    assert_field '', 'Cody'
    assert_field '', 'Fauser'
    assert_field '', 'cody@example.com'
  end

  def test_address_mapping
    @helper.billing_address :address1 => '1 My Street',
                            :address2 => '',
                            :city => 'Leeds',
                            :state => 'Yorkshire',
                            :zip => 'LS2 7EE',
                            :country  => 'CA'

    assert_field '', '1 My Street'
    assert_field '', 'Leeds'
    assert_field '', 'Yorkshire'
    assert_field '', 'LS2 7EE'
  end

  def test_unknown_address_mapping
    @helper.billing_address :farm => 'CA'
    assert_equal 3, @helper.fields.size
  end

  def test_unknown_mapping
    assert_nothing_raised do
      @helper.company_address :address => '500 Dwemthy Fox Road'
    end
  end

  def test_setting_invalid_address_field
    fields = @helper.fields.dup
    @helper.billing_address :street => 'My Street'
    assert_equal fields, @helper.fields
  end
end
