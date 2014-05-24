require File.expand_path('../../../test_helper', __FILE__)

class BaseGroupTest < Test::Unit::TestCase
  include SamlTestHelper
  
  setup do
    @saml_response = Maestrano::Saml::Response.new(response_document)
    @saml_response.stubs(:attributes).returns({
      'mno_session'          => 'f54sd54fd64fs5df4s3d48gf2',
      'mno_session_recheck'  => Time.now.utc.iso8601,
      'group_uid'            => 'cld-1',
      'group_end_free_trial' => Time.now.utc.iso8601,
      'group_role'           => 'Admin',
      'uid'                  => "usr-1",
      'virtual_uid'          => "usr-1.cld-1",
      'email'                => "j.doe@doecorp.com",
      'virtual_email'        => "usr-1.cld-1@mail.maestrano.com",
      'name'                 => "John",
      "surname"              => "Doe",
      "country"              => "AU",
      "company_name"         => "DoeCorp"
    })
  end
  
  should "have a local_id accessor" do
    assert Maestrano::SSO::BaseGroup.new(@saml_response).respond_to?(:local_id) == true
  end
  
  should "extract the rights attributes from the saml response" do
    group = Maestrano::SSO::BaseGroup.new(@saml_response)
    assert group.uid == @saml_response.attributes['group_uid']
    assert group.free_trial_end_at == Time.iso8601(@saml_response.attributes['group_end_free_trial'])
    assert group.company_name == @saml_response.attributes['company_name']
    assert group.country == @saml_response.attributes['country']
  end
end