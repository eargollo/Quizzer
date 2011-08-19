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
  
  def teardown
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
    (0.. DB_WORDS.size - 1).each do |i|
      word = dict.retrieve(:id => i)
      assert_equal(DB_WORDS[i][0], word.word)
      assert_equal(DB_WORDS[i][1], word.meaning)
    end
    assert_raise(RuntimeError) { dict.insert(:word => DB_WORDS[0][0], :meaning => "new meaning") }
    assert_not_equal("new meaning", dict.retrieve(:id => 0).meaning)
    assert_equal(DB_WORDS[0][1], dict.retrieve(:id => 0).meaning)
    dict.insert({:word => DB_WORDS[0][0], :meaning => "zero"}, :duplicate => :replace)
    assert_equal("zero", dict.retrieve(:id => 0).meaning)
    dict.insert({:word => DB_WORDS[0][0], :meaning => "one"}, :duplicate => :ignore)
    assert_equal("zero", dict.retrieve(:id => 0).meaning)
  end
  
  def test_csv_good
    dict = Quizzer::Model::Dictionary.new(DB_FILE)
    dict.insert_csv(File.dirname(__FILE__) + "/fixtures/csv/good.csv")
    assert_equal(44, dict.size)
  end
  
  def test_csv_duplicate
    dict = Quizzer::Model::Dictionary.new(DB_FILE)
    assert_equal(0, dict.size)
    #Test that either it is all or nothing in case of fail
    assert_raise(RuntimeError) { dict.insert_csv(File.dirname(__FILE__) + "/fixtures/csv/with_duplicates.csv") }
    assert_equal(0, dict.size)
    dict.insert_csv(File.dirname(__FILE__) + "/fixtures/csv/with_duplicates.csv", :duplicate => :ignore)
    assert_equal(3, dict.size)
    assert_equal("primeiro", dict.retrieve(:id => 0).meaning)
    dict.insert_csv(File.dirname(__FILE__) + "/fixtures/csv/with_duplicates.csv", :duplicate => :replace)
    assert_equal(3, dict.size)
    assert_equal("primero", dict.retrieve(:id => 0).meaning)
  end
  
  def test_with_errors
    dict = Quizzer::Model::Dictionary.new(DB_FILE)
    dict.insert_csv(File.dirname(__FILE__) + "/fixtures/csv/with_errors.csv")
    assert_equal(4, dict.size)
  end
end