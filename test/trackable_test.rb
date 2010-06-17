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
  
  def test_desired_nil_string_messaging
    foo = Foo.create
    foo.update_attribute(:status, nil)
    assert_equal 0, foo.events.size
  end
  
  def test_desired_new_blank_string_messaging
    foo = Foo.new(:status => "")
    foo.save
    assert_equal 0, foo.events.size
  end
  
  def test_desired_existing_nil_string_messaging
    foo = Foo.create(:status => "bazzed")
    assert_equal 1, foo.events.size    
    foo.update_attribute(:status, nil)
    assert_equal 2, foo.events.size
  end 
  
  def test_desired_existing_nil_string_messaging
    foo = Foo.create(:status => "bazzed")
    assert_equal 1, foo.events.size    
    foo.update_attribute(:status, nil)
    assert_equal 2, foo.events.size
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
  
  def test_desired_reference_like_messaging
    foo = Foo.create
    foo.update_attribute(:alternate_identification, "Only a string")
    assert_equal "Alternate identification changed to Only a string", foo.events.first.message
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
  
  def test_untracked_changes
    foo = Foo.create
    foo.update_attribute(:do_not_track, "Untracked")
    assert_equal 0, foo.events.size    
  end
  
  def test_checks_for_associations_when_creating_message
    foo = Foo.create
    assert_nothing_raised { foo.update_attribute(:not_association_id, 1) }
    assert_equal "Not association changed to 1", foo.events.first.message
  end
  
  def test_dropping_trackable_on_model_works
    assert_nothing_raised { Bar.trackable }
    bar = Bar.create
    bar.update_attribute(:name, "Megatron")
    assert_equal "Name changed to Megatron", bar.events.first.message
  end
  
  def test_trackable_can_be_set_to_only_record_on_create
    Bar.instance_variable_set :@after_save_callbacks, ActiveSupport::Callbacks::CallbackChain.new
    Bar.trackable :on => :create
    bar = Bar.create(:name => 'bar')
    assert_equal "Name changed to bar", bar.events.first.message
    assert_equal 1, bar.events.count
    bar.update_attributes(:name => 'baz')
    assert_equal 1, bar.events.count
  end
  
  def test_trackable_can_be_set_to_only_record_on_update
    Bar.instance_variable_set :@after_create_callbacks, ActiveSupport::Callbacks::CallbackChain.new
    Bar.trackable :on => :update
    bar = Bar.create(:name => 'bar')
    assert_equal 0, bar.events.count
    bar.update_attributes(:name => 'baz')
    assert_equal "Name changed to baz", bar.events.first.message
    assert_equal 1, bar.events.count
  end
    
  def test_trackable_can_record_delete_events
    Bar.instance_variable_set :@after_save_callbacks, ActiveSupport::Callbacks::CallbackChain.new
    Bar.trackable :on => :create
    bar = Bar.create(:name => 'bar')
    assert_equal "Name changed to bar", bar.events.first.message
    assert_equal 1, bar.events.count
    bar.destroy
    assert_equal 4, bar.events.count
    assert_equal "Bar(#{bar.id}) deleted.", bar.events.last.message
  end
  
  def test_trackable_event_returns_object
    Bar.instance_variable_set :@after_save_callbacks, ActiveSupport::Callbacks::CallbackChain.new
    Bar.trackable :on => :create
    bar = Bar.create(:name => 'bar')
    assert_equal bar, bar.events.first.eventable
    bar.destroy
    assert_equal nil, bar.events.first.eventable
  end
    
end
