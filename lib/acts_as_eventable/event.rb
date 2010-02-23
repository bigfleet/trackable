class Event < ActiveRecord::Base
  
  def self.attributes_from(eventable_options, key, old_val, new_val)
    {:field_name => key}
  end
end