require 'test_helper'

class UniversalModuleTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Integrations

  def test_credential_based_url
    assert_equal 'zork', Universal.credential_based_url(:forward_url => 'zork')
  end

  def test_notification
    assert_instance_of Universal::Notification, Universal.notification('name=cody')
  end

  def test_return
    assert_instance_of Universal::Return, Universal.return('name=cody')
  end

  def test_sign
    expected = Digest::HMAC.hexdigest('a1b2', 'zork', Digest::SHA256)
    assert_equal expected, Universal.sign({:b => '2', :a => '1'}, 'zork')
  end

end
