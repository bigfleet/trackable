class Event < ActiveRecord::Base
  
  def self.attributes_from(eventable_options, key, old_val, new_val)
    msg = if eventable_options[:events][key.to_sym] && eventable_options[:events][key.to_sym][new_val]
      eventable_options[:events][key.to_sym][new_val]
    else
      "#{key.titleize} changed to #{new_val}"
    end
    {:field_name => key, :message => msg}
  end
end