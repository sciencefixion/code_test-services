require File.expand_path('../support/test_helper', __dir__)

require 'minitest/autorun'


class ApiTest < Minitest::Test

  def test_no_api_key
    make_request('?s=star', 'http://www.omdbapi.com/')
  
    expected = "{\"Response\":\"False\",\"Error\":\"No API key provided.\"}"

    assert_equal last_response.body, expected
  end

  def test_it_can_search_thomas
    make_request("?s=thomas&apikey=#{ENV['OMDB_KEY']}", 'http://www.omdbapi.com/')

    assert_instance_of Hash, parsed_response
    assert_equal parsed_response[:Search].size, 10

    search_results.each do |r|
      assert r[:Title].downcase.include?('thomas')
      assert r.has_key?(:Title)
      assert r.has_key?(:Year)
      assert r.has_key?(:imdbID)
      assert r.has_key?(:Type)
      assert r.has_key?(:Poster)
      assert_kind_of String, r[:Title]
      assert_kind_of String, r[:Year]
      assert_kind_of String, r[:imdbID]
      assert_kind_of String, r[:Type]
      assert_kind_of String, r[:Poster]
      if r[:Type] == "movie" || r[:Type] == "episode"
        assert_equal 4, r[:Year].size
      else
        assert_equal 9, r[:Year].size
      end
    end
  end

  def test_for_valid_imdbIDs
    make_request("?s=thomas&apikey=#{ENV['OMDB_KEY']}", 'http://www.omdbapi.com/')

    imdbID_arr = search_results.reduce(Array.new) do |arr, r|
      arr << r[:imdbID]
      arr
    end

    imdbID_arr.each do |id|
      assert_equal 9 || 10 , id.size
      assert_equal "tt", id[0..1]
      assert_kind_of Integer, id[2..8].to_i
    end

    imdbID_arr.each do |id|
      make_request("?i=#{id}&apikey=#{ENV['OMDB_KEY']}", 'http://www.omdbapi.com/')

      assert parsed_response[:Response]
    end
  end

  def test_for_valid_image_links_on_page_one
    make_request("?s=thomas&apikey=#{ENV['OMDB_KEY']}", 'http://www.omdbapi.com/')

    search_results.each do |r|
      assert_equal 200, make_request(r[:Poster]).status
    end
  end

  def test_for_no_duplicate_records_across_first_five_pages
    five_page_arr = [1..5].each do |num|
      five_pages_results = []
      make_request("?s=thomas&apikey=#{ENV['OMDB_KEY']}&page=#{num}", 'http://www.omdbapi.com/')

      search_results.each do |r|
        five_pages_results << r
      end
      five_pages_results
    end

    duplicates = five_page_arr.detect {|e| five_page_arr.rindex(e) != five_page_arr.index(e)}

    assert_nil duplicates
  end

  def test_for_writer_director_star_of_the_room
    make_request("?t=The Room&y=2003&apikey=#{ENV['OMDB_KEY']}", 'http://www.omdbapi.com/')

    assert_equal "Tommy Wiseau", parsed_response[:Writer]
    assert_equal "Tommy Wiseau", parsed_response[:Director]
    assert_includes parsed_response[:Actors], "Tommy Wiseau"
  end
end
