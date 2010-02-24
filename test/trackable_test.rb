require 'test_helper'

class TrackableTest < Test::Unit::TestCase

  load_schema

  def test_schema_has_loaded_correctly
    Foo.create
    Bar.create
    assert Foo.count >= 1
    assert Bar.count >= 1    
  end
  
  def test_cattr_accessor_installed
    assert_not_nil Foo.eventable_options
  end
  
  def test_desired_boolean_change_trigger
    foo = Foo.create
    foo.update_attribute(:no_homers, true)
    assert_equal 1, foo.events.size
  end
  
  def test_desired_boolean_messaging
    foo = Foo.create
    foo.update_attribute(:no_homers, true)
    assert_equal "Homers have been barred.", foo.events.first.message
  end

  def test_desired_boolean_messaging_stackable
    foo = Foo.create
    foo.update_attribute(:no_homers, true)
    sleep 1 #mur
    foo.update_attribute(:no_homers, false)    
    assert_equal "Homers have been allowed.", foo.events.first.message    
    assert_equal "Homers have been barred.", foo.events.last.message
  end
  
  def test_desired_string_change_trigger
    foo = Foo.create
    foo.update_attribute(:status, "New")
    assert_equal 1, foo.events.size
  end
  
  def test_desired_string_messaging
    foo = Foo.create
    foo.update_attribute(:status, "New")
    assert_equal "Status changed to New", foo.events.first.message
  end
  
  def test_desired_string_stackability
    foo = Foo.create
    foo.update_attribute(:status, "Old")
    sleep 1 #mur    
    foo.update_attribute(:status, "New")    
    assert_equal "Status changed to New", foo.events.first.message
    assert_equal "Status changed to Old", foo.events.last.message    
  end
  
  def test_desired_custom_string_change_trigger
    foo = Foo.create
    foo.update_attribute(:custom_status, "New")
    assert_equal 1, foo.events.size
  end
  
  def test_desired_custom_string_messaging
    foo = Foo.create
    foo.update_attribute(:custom_status, "New")
    assert_equal "The value of a custom string field changed to New", foo.events.first.message
  end
  
  def test_desired_custom_string_stackability
    foo = Foo.create
    foo.update_attribute(:custom_status, "Old")
    sleep 1 #mur    
    foo.update_attribute(:custom_status, "New")    
    assert_equal "The value of a custom string field changed to New", foo.events.first.message
    assert_equal "The value of a custom string field changed to Old", foo.events.last.message    
  end  
  
  def test_desired_reference_change_trigger
    foo = Foo.create
    bar = Bar.create(:name => "Baloney")
    foo.bar = bar; foo.save
    assert_equal 1, foo.events.size
  end
  
  def test_desired_reference_messaging
    foo = Foo.create
    bar = Bar.create(:name => "Baloney")
    foo.bar = bar; foo.save
    assert_equal "Bar changed to Baloney", foo.events.first.message
  end
  
  def test_desired_reference_stackability
    foo = Foo.create
    bar1 = Bar.create(:name => "Peanut Butter")
    bar2 = Bar.create(:name => "Jelly")
    foo.bar = bar1; foo.save
    sleep 1 #mur    
    foo.bar = bar2; foo.save
    assert_equal "Bar changed to Jelly", foo.events.first.message
    assert_equal "Bar changed to Peanut Butter", foo.events.last.message    
  end
  
  def test_desired_custom_reference_change_trigger
    foo = Foo.create
    bar = Bar.create(:name => "Baloney")
    foo.custom_bar = bar; foo.save
    assert_equal 1, foo.events.size
  end
  
  def test_desired_custom_reference_messaging
    foo = Foo.create
    bar = Bar.create(:name => "Baloney")
    foo.custom_bar = bar; foo.save
    assert_equal "Active Bar set to Baloney", foo.events.first.message
  end
  
  def test_desired_custom_reference_stackability
    foo = Foo.create
    bar1 = Bar.create(:name => "Peanut Butter")
    bar2 = Bar.create(:name => "Jelly")
    foo.custom_bar = bar1; foo.save
    sleep 1 #mur    
    foo.custom_bar = bar2; foo.save
    assert_equal "Active Bar set to Jelly", foo.events.first.message
    assert_equal "Active Bar set to Peanut Butter", foo.events.last.message    
  end  
  
end
