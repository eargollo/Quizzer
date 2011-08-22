require 'yaml'

TEST_DATA = <<END_TEST_DATA
---
:title: Big Five Personality Test
:value_sets:
  sex:
    - :label: Male
      :value: :male
    - :label: Female
      :value: :female
  positive:
    - :label: Very uncharacteristic
      :value: 1
    - :label: Moderately uncharacteristic
      :value: 2
    - :label: Neither uncharacteristic nor characteristic
      :value: 3
    - :label: Moderately characteristic
      :value: 4
    - :label: Very characteristic
      :value: 5
  negative:
    - :label: Very uncharacteristic
      :value: 5
    - :label: Moderately uncharacteristic
      :value: 4
    - :label: Neither uncharacteristic nor characteristic
      :value: 3
    - :label: Moderately characteristic
      :value: 2
    - :label: Very characteristic
      :value: 1
:questions:
  - :question: What sex are you
    :value_set: sex
  - :question: Starting a conversation with a stranger
    :value_set: positive
  - :question: Making sure others are comfortable and happy
    :value_set: positive
  - :question: Creating an artwork, piece of writing, or piece of music
    :value_set: positive
  - :question: Preparing for things well in advance
    :value_set: positive
  - :question: Feeling blue or depressed
    :value_set: positive
  - :question: Planning parties or social events
    :value_set: positive
  - :question: Insulting people
    :value_set: negative
  - :question: Thinking about philosophical or spiritual questions
    :value_set: positive
  - :question: Letting things get into a mess
    :value_set: negative
  - :question: Feeling stressed or worried
    :value_set: positive
  - :question: Using difficult words
    :value_set: positive
  - :question: Sympathizing with others' feelings
    :value_set: positive
:traits:
  - :name: Extraversion
    :core_mechanism: Response to reward (mid-brain dopamine reward systems)
    :benefits: Increased reward pursuit and capture
    :costs: Physical dangers, family instability
    :questions: [ 1, 6 ]
    :scoring:
      :male:   [ ~, ~, low, low, low, low-medium, low-medium, 
                medium-high, medium-high, high, high]
      :female: [ ~, ~, low, low, low, low-medium, low-medium, 
                 medium-high, medium-high, high, high]
  - :name: Neuroticism
    :core_mechanism: Response to threat (amygdala and limbic system, serotonin)
    :benefits: Vigilance, striving
    :costs: Anxiety, depression
    :questions: [ 5, 10 ]
    :scoring:
      :male:   [ ~, ~, low, low, low, low-medium, low-medium, 
                medium-high, medium-high, high, high]
      :female: [ ~, ~, low, low, low, low-medium, low-medium, 
                 medium-high, medium-high, high, high]
  - :name: Conscientiousness
    :core_mechanism: Response inhibition dorsolateral prefrontal cortex)
    :benefits: Planning, self-control
    :costs: Rigidity, lack of spontaneous response
    :questions: [ 4, 9 ]
    :scoring:
      :male:   [ ~, ~, low, low, low, low-medium, low-medium, 
                medium-high, medium-high, high, high]
      :female: [ ~, ~, low, low, low, low-medium, low-medium, 
                 medium-high, medium-high, high, high]
  - :name: Agreeableness
    :core_mechanism: Regard for others (Theory of mind, empathy component)
    :benefits: Harmonious social relationships
    :costs: Not putting self first, lost status
    :questions: [ 2, 7, 12]
    :scoring:
      :male: [~, ~, ~, low, low, low, low, low, low, low, 
              low-medium, low-medium, medium-high, medium-high, high, high ]
      :female: [~, ~, ~, low, low, low, low, low, low, low, low, low,
                low-medium, low-medium, medium-high, high ]

  - :name: Openness
    :core_mechanism: Breadth of mental associations
    :benefits: Artistic sensibility, divergent thought
    :costs: Unusual beliefs, proneness to psychosis
    :questions: [ 3, 8, 11]
    :scoring:
      :male:   [ ~, ~, ~, low, low, low, low, low, low,
                 low-medium, low-medium, medium-high, medium-high, high, high, high ]
      :female: [ ~, ~, ~, low, low, low, low, low, low,
                 low-medium, low-medium, medium-high, medium-high, high, high, high ]

END_TEST_DATA




class PrettyButton < Shoes::Widget
  def initialize(label, col=nil)
    col ||= rgb(rand * 0.3 + 0.7, rand * 0.3 + 0.7, rand * 0.3 + 0.7, 0.5)
    flow :margin => 20 do
      background col, :curve => 20
      para label, :align => 'center'
      click { yield }
      hover { |me| me.append { @hoverbg = background rgb(1.0,1.0,1.0,0.5), :curve => 20 } }
      leave { @hoverbg.remove}
    end
  end
end

Shoes.app :width => 600 do
  def show_question(num=nil)
    bg_color = rgb(rand * 0.5 + 0.25, rand * 0.5 + 0.25, rand * 0.5 + 0.25)
    button_color = rgb(rand * 0.3 + 0.7, rand * 0.3 + 0.7, rand * 0.3 + 0.7, 0.5)
    @title_stack.clear { background bg_color, :curve => 20; caption @title, :align => 'center' }
    @question_stack.clear do
      background bg_color, :curve => 20

      if num < @questions.length
        question = @questions[num]
        caption "#{ num + 1 }/#{@questions.length}: #{question[:question]}", :align => 'center'

        @value_sets[question[:value_set]].each do | item |
          pretty_button(item[:label], button_color) do 
            @answers[num] = item[:value]
            show_question(num + 1)
          end
        end
      else
        sex = @answers[0]
        @textual_summary = ""
        @traits.each do |trait|
          score = 0
          trait[:questions].each do | num |
            score = score + @answers[num]
          end
          interpretation = trait[:scoring][sex][score]

          @textual_summary << caption( em(trait[:name])).text << "\n\n" <<
            para( "level: ", em(interpretation)).text  << "\n" <<
            para( "core mechanism: ", em(trait[:core_mechanism])).text << "\n" <<
            para( "benefits: ", em(trait[:benefits])).text << "\n" <<
            para( "costs: ", em(trait[:costs])).text << "\n\n"
        end
        pretty_button( "copy results to clipboard", button_color ) do
          alert "copied results to clipboard."
          self.clipboard = @textual_summary
        end
        pretty_button( "start over", button_color ) do
          @answers = []
          show_question 0
        end
      end
    end
  end

  @test = YAML.load(TEST_DATA)
  @title = @test[:title]
  @questions = @test[:questions]
  @value_sets = @test[:value_sets]
  @traits = @test[:traits]
  @answers = []

  background black

  @title_stack = stack :margin => 20
  
  @question_stack = stack :margin => 20
  show_question 0

end

