require_relative 'test_helper'

describe Recipient do
  describe 'constructor' do
    it "creates a Recipient object" do
      test = Recipient.new("C01BKP7MWNB", "random")
      expect(test).must_be_kind_of Recipient
    end
  end

  describe 'send_message' do

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
          Recipient.get("https://slack.com/api/monkeys", {token: ENV['SLACK_TOKEN']})
        end.must_raise SlackApiError
      end
    end

    it 'returns a response for url and legal params'
    VCR.use_cassette("Recipient.get") do
      url = "https://slack.com/api/conversations.list"
      param = {token: ENV['SLACK_TOKEN']}
      response = Recipient.get(url, param)
      # need to find expect that actually works
    end
    end

  describe 'details' do
    it "raises NotImplementedError if called from Recipient" do
      test = Recipient.new("C01BKP7MWNB", "random")
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