class Event < ActiveRecord::Base
  
  def self.attributes_from(eventable_options, key, old_val, new_val)
    msg = eventable_options[:events][key.to_sym][new_val]
    {:field_name => key, :message => msg}
  end
end