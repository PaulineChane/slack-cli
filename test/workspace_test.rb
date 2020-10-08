require_relative 'test_helper'

describe Workspace do
  before do
    VCR.use_cassette("workspace") do
      @ws = Workspace.new
    end
  end
  describe "constructor" do
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
          expect(@ws.users[i].time_zone).must_equal user_list[i].time_zone
          # NOTE: in the data from Slack API, Slackbot is not considered a bot!
          expect(@ws.users[i].is_bot).must_equal user_list[i].is_bot
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

  describe "select_user" do
    it "returns user input for successful match" do
      slackbot = @ws.users.find{|user| user.slack_id == "USLACKBOT"}


      @ws.select_user("slackbot") # by name
      expect(@ws.selected).must_equal slackbot

      @ws.select_user(nil) # to reset

      @ws.select_user("USLACKBOT") # by ID
      expect(@ws.selected).must_equal slackbot
    end
    it "returns nil for cases when user name/slack id are not matched" do
      expect(@ws.select_user(nil)).must_be_nil
      # slack usernames have a 21 character limit
      expect(@ws.select_user("SlackSlackSlackSlackSlack")).must_be_nil
    end
  end

  describe "select_channel" do
    it "returns channel input for successful match" do
      random = @ws.channels.find{|channel| channel.name == "random"}


      @ws.select_channel("random") # by name
      expect(@ws.selected).must_equal random

      @ws.clear_selection # to reset

      @ws.select_channel(random.slack_id) # by ID
      expect(@ws.selected).must_equal random
    end
    it "returns nil for cases when channel name/slack id are not matched" do
      expect(@ws.select_channel(nil)).must_be_nil
      # slack usernames have a 21 character limit
      expect(@ws.select_channel("SlackSlackSlackSlackSlack")).must_be_nil
    end
  end

  describe "clear_selection" do
    it "clears @selected field in workspace" do
      @ws.select_user("slackbot")
      @ws.clear_selection
      expect(@ws.selected).must_be_nil
    end
  end

  describe "show_details" do
    it "returns return of .details of recipient selected" do
      @ws.select_user("slackbot")
      temp_store = @ws.selected.details # since show_details resets selected, save this
      user_detail = @ws.show_details

      # compare temp_store details with show_details results
      expect(user_detail).must_be_instance_of Hash
      expect(user_detail[:SLACK_ID]).must_equal temp_store[:SLACK_ID]
      expect(user_detail[:NAME]).must_equal temp_store[:NAME]
      expect(user_detail[:REAL_NAME]).must_equal temp_store[:REAL_NAME]
      expect(user_detail[:TIME_ZONE]).must_equal temp_store[:TIME_ZONE]
      # NOTE: in the data from Slack API, Slackbot is not considered a bot!
      expect(user_detail[:IS_BOT]).must_equal temp_store[:IS_BOT]
    end
    it "returns nil if no recipient selected" do
      expect(@ws.show_details).must_be_nil
    end
  end

  describe "send_message" do
    it "returns nil if no recipient is selected " do
      VCR.use_cassette("Workspace send_message") do
        expect(@ws.send_message("hi")).must_be_nil
      end
    end
    it "sends a message when a recipient is selected" do
      VCR.use_cassette("Workspace send_message") do
        user = @ws.users.find{ |user| user.name == "slackbot" }
        # select user to send message to
        @ws.select_user("slackbot")
        response = @ws.send_message("HEY LISTEN")
        # verify correct channel
        url = "https://slack.com/api/conversations.members"
        query = {token: Recipient.token, channel: response['channel']}
        channel_members = HTTParty.get(url, query: query)
        expect(response).must_be_instance_of Hash
        expect(response['message']['text']).must_equal "HEY LISTEN"
        # for DMs since this is to a DM with Slackbot
        expect(channel_members['members']).must_include user.slack_id
      end
    end
  end
end
