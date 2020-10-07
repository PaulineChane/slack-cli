require_relative 'test_helper'

describe Workspace do
  describe "constructor" do
    before do
      VCR.use_cassette("workspace") do
        @ws = Workspace.new
      end
    end
    it "correctly initializes workspace with a list of channels and users from Slack workspace" do
      # Arrange and Act
      VCR.use_cassette("workspace") do
        user_list = User.list_all
        channel_list = Channel.list_all

        # Assert
        expect(@ws).must_be_instance_of Workspace
        expect(@ws.users).must_be_instance_of Array
        expect(@ws.channels).must_be_instance_of Array
        user_list.length.times do |i|
          expect(@ws.users[i]).must_be_kind_of User
          expect(@ws.users[i].slack_id).must_equal user_list[i].slack_id
          expect(@ws.users[i].name).must_equal user_list[i].name
          expect(@ws.users[i].real_name).must_equal user_list[i].real_name
          expect(@ws.users[i].status_text).must_equal user_list[i].status_text
          expect(@ws.users[i].status_emoji).must_equal user_list[i].status_emoji
        end
        channel_list.length.times do |i|
          expect(@ws.channels[i]).must_be_kind_of Channel
          expect(@ws.channels[i].slack_id).must_equal channel_list[i].slack_id
          expect(@ws.channels[i].name).must_equal channel_list[i].name
          expect(@ws.channels[i].topic).must_equal channel_list[i].topic
          expect(@ws.channels[i].member_count).must_equal channel_list[i].member_count
        end
      end
    end
  end
end