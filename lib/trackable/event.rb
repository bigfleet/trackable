class Event < ActiveRecord::Base
  
  def self.attributes_from(model, key, old_val, new_val)
    eventable_options = model.class.eventable_options
    msg = if eventable_options[:events][key.to_sym] && eventable_options[:events][key.to_sym][new_val]
      eventable_options[:events][key.to_sym][new_val]
    elsif eventable_options[:events][key.to_sym] && eventable_options[:events][key.to_sym][:message]
      the_proc = eventable_options[:events][key.to_sym][:message]
      if key.index("_id") # hackish, but this is a convention
        reference = key[0..-4].to_sym
        the_proc.call(model.send(reference).to_s)
      else
        the_proc.call(new_val)
      end
    elsif key.index("_id") # hackish, but this is a convention
      reference = key[0..-4].to_sym
      "#{key.titleize} changed to #{model.send(reference).to_s}"
    else
      "#{key.titleize} changed to #{new_val}"
    end
    {:field_name => key, :message => msg, :whodunnit => Trackable.whodunnit}
  end
end