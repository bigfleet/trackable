class Event < ActiveRecord::Base
  
  def self.attributes_from(model, key, old_val, new_val)
    return if old_val.blank? && new_val.blank? #not something we need to track.
    eventable_options = model.class.eventable_options
    return if [eventable_options[:exclude]].flatten.include?(key.to_sym)
    reference = key[0..-4].to_sym if key.ends_with?("_id")
    msg = if eventable_options[:events][key.to_sym] && eventable_options[:events][key.to_sym][new_val]
      eventable_options[:events][key.to_sym][new_val]
    elsif eventable_options[:events][key.to_sym] && eventable_options[:events][key.to_sym][:message]
      the_proc = eventable_options[:events][key.to_sym][:message]
      if key.ends_with?("_id") && model.class.reflect_on_association(reference) # hackish, but this is a convention
        the_proc.call(model.send(reference).to_s)
      else
        the_proc.call(new_val)
      end
    elsif key.ends_with?("_id") && model.class.reflect_on_association(reference) # hackish, but this is a convention
      "#{key.humanize} changed to #{model.send(reference).to_s}"
    else
      "#{key.humanize} changed to #{new_val}"
    end
    {:field_name => key, :message => msg, :whodunnit => Trackable.whodunnit}
  end
  
end