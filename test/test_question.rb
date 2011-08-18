require File.dirname(__FILE__) + '/test_helper.rb'

class TestQuestion < Test::Unit::TestCase

  def setup
  end
  
  def test_creation
    answers = ["Answer 1", "Answer 2", "Answer 3"]
    question = "Question?"
    correct = 1
    q = Quizzer::Controller::Question.new(question, answers, correct)
    assert_equal(answers[correct], q.option)
    assert_equal(question, q.question)
    assert_equal(question, q.title)
    assert_equal(answers.size, q.size)
    assert_equal(answers, q.options)
    assert_equal(correct, q.correct)
  end
  
  def test_listener
    answers = ["Answer 1", "Answer 2", "Answer 3"]
    question = "Question?"
    correct = 1
    @q = Quizzer::Controller::Question.new(question, answers, correct)
    assert_equal(false, @q.correct?(2))
    @q.add_listener(self)
    @triggered = false
    assert_equal(false, @q.correct?(2))
    assert_equal(true, @triggered)
  end
  
  def answer_trigger(question, id, attempt, answer)
    assert_equal(@q, question)
    @triggered = true
  end
end
