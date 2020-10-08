require_relative 'test_helper'

describe User do
  before do
    @user = User.new(slack_id: "USLACKBOT", name: "slackbot", real_name: "Slackbot", is_bot: true)
  end
  describe 'constructor' do
    it "creates an instance of user with appropriate fields" do
      # Assert
      expect(@user).must_be_instance_of User
      expect(@user).must_be_kind_of Recipient
      expect(@user.slack_id).must_equal "USLACKBOT"
      expect(@user.name).must_equal "slackbot"
      expect(@user.real_name).must_equal "Slackbot"
      expect(@user.time_zone).must_equal "Pacific Daylight Time"
      expect(@user.is_bot).must_equal true
    end
  end
  describe 'details' do
    it "lists the details for a user" do
      # Arrange and Act
      user_details = @user.details

      # Assert
      expect(user_details).must_be_kind_of Hash
      expect(user_details[:SLACK_ID]).must_equal @user.slack_id
      expect(user_details[:NAME]).must_equal @user.name
      expect(user_details[:REAL_NAME]).must_equal @user.real_name
      expect(user_details[:TIME_ZONE]).must_equal @user.time_zone
      expect(user_details[:IS_BOT]).must_equal @user.is_bot
    end
  end
  describe 'self.list_all' do
    it "returns all users in the workspace" do
      VCR.use_cassette("list_all") do
        # Arrange
        USERS_URL = "https://slack.com/api/users.list"
        # SLACK_TOKEN = ENV["SLACK_TOKEN"]
        response = HTTParty.get(USERS_URL, query: {token: User.token})["members"]
        response = response.filter{ |member| !member["deleted"]} # remove deleted members
        # Act
        users = User.list_all

        # Assert
        expect(User.list_all.length).must_equal response.length
        response.length.times do |i|
          expect(response[i]["id"]).must_equal users[i].slack_id
          expect(response[i]["name"]).must_equal users[i].name
          expect(response[i]["real_name"]).must_equal users[i].real_name
          expect(response[i]["tz_label"]).must_equal users[i].time_zone
          expect(response[i]["is_bot"]).must_equal users[i].is_bot
        end

        # NOTE: We didn't write a test to check whether the token is valid because that has already been tested in the
        # .get method in Recipient.rb from which it inherits, meaning it should work here too for user.rb
      end
    end
  end
end
