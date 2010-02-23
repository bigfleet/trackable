require 'test_helper'

class ActsAsEventableTest < Test::Unit::TestCase

  load_schema

  class Foo < ActiveRecord::Base
    acts_as_eventable :events =>{
      :no_homers => {true => "Homers have been barred.", false => "Homers have been allowed."}
    }
  end

  class Bar < ActiveRecord::Base
  end

  def test_schema_has_loaded_correctly
    Foo.create
    Bar.create
    assert Foo.count >= 1
    assert Bar.count >= 1    
  end
  
  def test_desired_boolean_messaging
    foo = Foo.create
    foo.update_attribute(:no_homers, true)
    assert_equal 1, foo.events.size
  end
end
