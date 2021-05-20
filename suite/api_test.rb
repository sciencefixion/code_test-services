require File.expand_path('../support/test_helper', __dir__)

require 'minitest/autorun'


class ApiTest < Minitest::Test

  def test_no_api_key
    make_request('?s=star', 'http://www.omdbapi.com/')
    # puts last_response.body


    expected = "{\"Response\":\"False\",\"Error\":\"No API key provided.\"}"

    assert_equal last_response.body, expected
  end

  def test_it_can_search_thomas
    make_request("?s=thomas&apikey=#{ENV['OMDB_KEY']}", 'http://www.omdbapi.com/')

    response = JSON.parse(last_response.body, symbolize_names: true)

    assert_instance_of Hash, response
    assert_equal response[:Search].size, 10

    results = response[:Search]

    results.each do |r|
      assert r[:Title].downcase.include?('thomas')
      assert r.has_key?(:Title)
      assert r.has_key?(:Year)
      assert r.has_key?(:imdbID)
      assert r.has_key?(:Type)
      assert r.has_key?(:Poster)
      # TODO: verify title value is a string
      # TODO: " year value is a string
      # TODO: " imdbID value is a string
      # TODO: " type value is a string
      # TODO: " Poster value is a string
      # TODO: Verify year matches correct format
    end
  end
end
