require File.dirname(__FILE__) + '/test_helper.rb'

class TestDictionary < Test::Unit::TestCase
  DB_FILE = File.dirname(__FILE__) + "/fixtures/temp-dictionary.pstore"

  DB_WORDS = [["eins", "one"],
              ["zwei", "two"],
              ["drei", "three"],
              ["vier", "four"],
              ["fuenf", "five"],
              ["sex", "six"],
              ["sieben", "seven"],
              ["acht", "eight"],
              ["neun", "nine"],
              ["zehn", "ten"]]
  
  def setup
    #Delete database if exists
    if File.exists?(DB_FILE)
      FileUtils.rm(DB_FILE)
    end
  end
  
  def test_initialize
    dict = Quizzer::Model::Dictionary.new(DB_FILE)
    DB_WORDS.each do |data|
      word = dict.insert(:word => data[0], :meaning => data[1])
      assert_equal(data[0], word.key)
      assert_equal(data[1], word.meaning)
    end
    assert_equal(DB_WORDS.size, dict.size)
  end
end