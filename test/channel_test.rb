require_relative 'test_helper'

describe "Channel" do
  before do
    @channel = Channel.new(slack_id: "C01BKP7MWNB", name: "random", topic: "", member_count: 2)
  end

  describe "Initialize method" do
    it "it creates an instance of channel" do
      expect(@channel).must_be_kind_of Channel
    end
  end

  describe "Details method" do
    it "lists the details for a channel" do
      expect(@channel.details).must_be_kind_of TablePrint::Returnable
    end
  end

  describe "List all method" do
    it "returns all channels in the workspace" do
      VCR.use_cassette("list_all") do
        CHANNELS_URL = "https://slack.com/api/conversations.list"
        SLACK_TOKEN = ENV["SLACK_TOKEN"]
        HTTParty.get(CHANNELS_URL, query: {token: SLACK_TOKEN })
        expect(Channel.list_all.length).must_equal 3
      end
    end
  end
end
