require_relative 'test_helper'

describe "Recipient" do
  describe 'constructor' do
    it "creates a Recipient object" do
      test = Recipient.new(slack_id: "C01BKP7MWNB",name: "random")
      expect(test).must_be_kind_of Recipient
      expect(test.slack_id).must_equal "C01BKP7MWNB"
      expect(test.name).must_equal "random"
    end
  end

  describe 'send_message' do
    before do
      # slackbot will be in every slack workspace
      @test = Recipient.new(slack_id: "USLACKBOT",name: "slackbot")
    end
    it 'returns message hash for successful messages for users' do
      VCR.use_cassette("send message to recipient") do
        message = "maracuyA"
        response = @test.send_message(message)
        # verify correct channel
        url = "https://slack.com/api/conversations.members"
        query = {token: Recipient.token, channel: response['channel']}
        channel_members = HTTParty.get(url, query: query)
        expect(response).must_be_instance_of Hash
        expect(response['message']['text']).must_equal message
        # for DMs since this is to a DM with Slackbot
        expect(channel_members['members']).must_include @test.slack_id
      end
    end
    it 'returns message hash for successful messages for channels' do
      VCR.use_cassette("send message to recipient") do
        channel = Recipient.new(slack_id: "C01BKP7MWNB",name: "random")
        message = "maracuyA"
        response = channel.send_message(message)
        expect(response).must_be_instance_of Hash
        # for messages to channels
        expect(response['channel']).must_include channel.slack_id
      end
    end
    it "rejects messages longer than 4000 characters" do
      VCR.use_cassette("send message to recipient") do
        message = ""
        4005.times do
          message += "A"
        end
        expect do
          @test.send_message(message)
        end.must_raise SlackApiError
      end
    end
    it "rejects attempts to send messages to invalid users/channels" do
      VCR.use_cassette("send message to recipient") do
        false_recipient = Recipient.new(slack_id: "0000000000000000000000", name: "false_user")
        message = "testing"
        expect do
          false_recipient.send_message(message)
        end.must_raise SlackApiError
      end
    end
    it "correctly sends message for customized bot" do
      VCR.use_cassette("send_message_to_recipient") do
        channel = Recipient.new(slack_id: "C01BKP7MWNB",name: "random")
        response = channel.send_message("hi", emoji: "dog", send_as: "woof")
        puts "hi"
        expect(response["message"]["username"]).must_equal "woof"
        expect(response["message"]["icons"]["emoji"]).must_equal "dog"
      end
    end
  end
  describe 'self.get' do
    it 'raises a SlackApiError if parameter input is invalid' do
      VCR.use_cassette("Recipient.get") do
        url = "https://slack.com/api/conversations.list"
        param = {token: 'blah'}
        expect do
          Recipient.get(url, param)
        end.must_raise SlackApiError
        expect do
          Recipient.get("https://slack.com/api/monkeys", {token: Recipient.token})
        end.must_raise SlackApiError
      end
    end

    it 'returns a response for url and legal params' do
      VCR.use_cassette("Recipient.get") do
        url = "https://slack.com/api/conversations.list"
        param = {token: Recipient.token}
        response = Recipient.get(url, param)
        expect(response["ok"]).must_equal true
      end
    end
  end
  describe 'details' do
    it "raises NotImplementedError if called from Recipient" do
      test = Recipient.new(slack_id: "C01BKP7MWNB", name: "random")
      expect do
        test.details
      end.must_raise NotImplementedError
    end
  end

  describe 'self.list_all' do
    it "raises NotImplementedError if called from Recipient" do
      expect do
        Recipient.list_all
      end.must_raise NotImplementedError
    end
  end
end