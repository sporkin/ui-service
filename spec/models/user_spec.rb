require 'spec_helper'

describe User do
  describe "#create" do
    it "cretes a user with uuid" do
      user = User.create :uuid => "foo"
      user.uuid.should == "foo"
    end
  end
end
