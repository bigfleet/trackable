class Event < ActiveRecord::Base
  
  def self.attributes_from(model, key, old_val, new_val)
    return if old_val.blank? && new_val.blank? # not something we need to track.
    eventable_options = model.class.eventable_options
    return if Array(eventable_options[:exclude]).include?(key.to_sym)
    
    events       = eventable_options[:events]
    attr_options = events[key.to_sym] if events
    reference    = key.ends_with?("_id") ? key[0..-4].to_sym : key.to_sym
    association  = model.class.reflect_on_association(reference)
    
    message = if attr_options && attr_options[new_val]
      attr_options[new_val]
    elsif attr_options && msg_proc = attr_options[:message]
      association ? msg_proc.call(model.send(reference).to_s) : msg_proc.call(new_val)
    elsif association
      "#{key.humanize} changed to #{model.send(reference).to_s}"
    else
      "#{key.humanize} changed to #{new_val}"
    end
    {:field_name => key, :message => message, :whodunnit => Trackable.whodunnit}
  end
  
  def eventable
    (self.eventable_type.constantize).find(self.eventable_id) rescue nil
  end
  
end