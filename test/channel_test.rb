require_relative 'test_helper'

describe "Channel" do
  before do
    @channel = Channel.new(slack_id: "C01BKP7MWNB", name: "random", topic: "", member_count: 2)
  end

  describe "Initialize method" do
    it "it creates an instance of channel" do
      expect(@channel).must_be_kind_of Recipient
      expect(@channel).must_be_instance_of Channel
      expect(@channel.slack_id).must_equal "C01BKP7MWNB"
      expect(@channel.name).must_equal "random"
      expect(@channel.topic).must_equal ""
      expect(@channel.member_count).must_equal 2
    end
  end

  describe "Details method" do
    it "lists the details for a channel" do
      # Arrange and Act
      channel_details = @channel.details

      # Assert
      expect(@channel.details).must_be_kind_of Hash
      expect(channel_details[:SLACK_ID]).must_equal @channel.slack_id
      expect(channel_details[:NAME]).must_equal @channel.name
      expect(channel_details[:TOPIC]).must_equal @channel.topic
      expect(channel_details[:MEMBER_COUNT]).must_equal @channel.member_count
    end
  end

  describe "List all method" do
    it "returns all channels in the workspace" do
      VCR.use_cassette("list_all") do
        # Arrange
        CHANNELS_URL = "https://slack.com/api/conversations.list"
        SLACK_TOKEN = ENV["SLACK_TOKEN"]
        response = HTTParty.get(CHANNELS_URL, query: {token: SLACK_TOKEN })["channels"]

        # Act
        channels = Channel.list_all

        # Assert
        expect(Channel.list_all.length).must_equal response.length
        response.length.times do |i|
          expect(response[i]["id"]).must_equal channels[i].slack_id
          expect(response[i]["name"]).must_equal channels[i].name
          expect(response[i]["topic"]["value"]).must_equal channels[i].topic
          expect(response[i]["num_members"]).must_equal channels[i].member_count
        end

        # NOTE: We didn't write a test to check whether the token is valid because that has already been tested in the
        # .get method in Recipient.rb from which it inherits, meaning it should work here too for channel.rb
      end
    end
  end
end
