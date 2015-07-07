require_relative '../models/event'
require_relative './base_mock'

module RescueGroups
  class EventMock < BaseMock
    class << self
      def mocked_class
        Event
      end

      def test_hash
        {
          "eventID"=>"36385",
          "eventOrgID"=>"4516",
          "eventName"=>"Weekly Mobile Adoption Event!!!",
          "eventStart"=>"1/22/2011 10:00 AM",
          "eventEnd"=>"1/22/2011 3:00 PM",
          "eventUrl"=>"",
          "eventDescription"=>"Come meet some of our fabulous dogs.  Find yourself a new best friend or help us save a life by fostering!  If you're interested in a particular dog, please email us and let us know so we can be sure she or he is there!",
          "eventLocationID"=>"10422",
          "eventSpecies"=>["Dog"],
          "locationName"=>"Pet Food Express",
          "locationUrl"=>"",
          "locationAddress"=>"Dolores and Market St.",
          "locationCity"=>"San Francisco ",
          "locationState"=>"CA",
          "locationPostalcode"=>"94114",
          "locationCountry"=>"United States",
          "locationPhone"=>"",
          "locationPhoneExt"=>"",
          "locationEvents"=>"0"
        }
      end
    end
  end
end
