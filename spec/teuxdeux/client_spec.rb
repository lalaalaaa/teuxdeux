# encoding: utf-8

require 'helper'

describe TeuxDeux::Client do
  it "should work with basic auth and password" do
    stub_request(:get, "https://foo:bar@teuxdeux.com/api/user.json").
      with(:headers => {'Accept'=>'*/*'}).
      to_return(:status => 200, :body => '{"id":42}', :headers => {})
    proc {
      TeuxDeux::Client.new(:login => 'foo', :password => 'bar').user
    }.should_not raise_exception
  end

  describe ".hash_to_params" do
    it "should turn a hash into url params" do
      client = TeuxDeux::Client.new

      client.hash_to_params({ :data => 1}).should == "data=1"

      client.hash_to_params({ :data => "with spaces"}).should == "data=with%20spaces"

      [
        "data[a]=1&data[b]=2",
        "data[b]=2&data[a]=1"
      ].include?(client.hash_to_params({ :data => { :a => 1, :b => 2 }})).should == true

      client.hash_to_params({ :data => { :foo => { :bar => 42 }, :b => 2 }}).should == "data[b]=2&data[foo][bar]=42"
    end
  end
end
