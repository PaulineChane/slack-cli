require_relative 'test_helper'

describe Bot do
  before do
    @bot = Bot.new(slack_id: "USLACKBOT", name: "slackbot", real_name: "Slackbot", time_zone: "Pacific Daylight Time", is_bot: true, send_as: "Bork", emoji: "dog")
  end

  describe "constructor" do
    it "creates an instance of bot with appropriate fields" do
      expect(@bot).must_be_instance_of Bot
      expect(@bot).must_be_kind_of User
      expect(@bot.slack_id).must_equal "USLACKBOT"
      expect(@bot.name).must_equal "slackbot"
      expect(@bot.real_name).must_equal "Slackbot"
      expect(@bot.time_zone).must_equal "Pacific Daylight Time"
      expect(@bot.is_bot).must_equal true
      expect(@bot.send_as).must_equal "Bork"
      expect(@bot.emoji).must_equal "dog"
    end
  end
  describe 'set_send_as' do
    it "sets name to user provided alias" do
      expect(@bot.set_send_as("Bork")).must_equal "Bork"
    end
  end
  describe 'set_emoji' do
    it "sets the emoji based on the provided emoji" do
      expect(@bot.set_emoji("dog")).must_equal "dog"
    end
    it "raises an error when the emoji is invalid format" do
      expect do
        @bot.set_emoji("??????")
      end.must_raise ArgumentError
    end
  end
  describe "self.list_all" do
    it "returns all users in the workspace" do
      VCR.use_cassette("bot list_all") do
        # Arrange
        BOTS_URL = "https://slack.com/api/users.list"
        # SLACK_TOKEN = ENV["SLACK_TOKEN"]
        response = HTTParty.get(BOTS_URL, query: {token: Bot.token})["members"]
        # account for slackbot and deleted members
        response = response.filter{ |member| (!member["deleted"] && member["is_bot"])|| member["id"] == "USLACKBOT"} # remove deleted members
        # Act
        bots = Bot.list_all

        # Assert
        expect(bots.length).must_equal response.length
        response.length.times do |i|
          expect(response[i]["id"]).must_equal bots[i].slack_id
          expect(response[i]["name"]).must_equal bots[i].name
          expect(response[i]["real_name"]).must_equal bots[i].real_name
          expect(response[i]["tz_label"]).must_equal bots[i].time_zone
          expect(response[i]["is_bot"]).must_equal bots[i].is_bot
        end
      end
    end
  end

  describe "send_message" do

  end
end

