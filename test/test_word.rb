require File.dirname(__FILE__) + '/test_helper.rb'

class TestWord < Test::Unit::TestCase
  def test_initialize
  	word = Quizzer::Model::Word.new(:word => "der Wolf", :meaning => "lobo", :language => :pt)
  	assert_equal("lobo", word.meaning)
  	assert_equal(:pt, word.get_complement(:language))
  	assert_equal(:substantive, word.type)
  	assert_equal("der Wolf", word.to_s)
  	assert_equal("Wolf", word[:word_parsed])
    assert_equal("Wolf", word.key)
  	assert_equal("der", word[:article])
  	
  	word = Quizzer::Model::Word.new(:word => "laufen", :meaning => "caminhar")
  	assert_equal("caminhar", word.meaning)
  	assert_equal(nil, word.get_complement(:language))
  	assert_equal(:unknown, word.type)
  	assert_equal("laufen", word.to_s)
  end
end