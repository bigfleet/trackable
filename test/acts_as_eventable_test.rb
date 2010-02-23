require 'test_helper'

class ActsAsEventableTest < ActiveSupport::TestCase
  load_schema

  class Foo < ActiveRecord::Base
  end

  class Bar < ActiveRecord::Base
  end

  def test_schema_has_loaded_correctly
    assert_equal [], Foo.all
    assert_equal [], Bar.all
    raise "I ran"
  end
end
