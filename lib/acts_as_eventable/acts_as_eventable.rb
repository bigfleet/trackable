module ActsAsEventable
  def self.included(base)
    base.send :extend, ClassMethods
    base.instance_eval{
      cattr_accessor :eventable_options
    } 
  end

  module ClassMethods

    def acts_as_eventable(options)
      instance_eval{
        self.eventable_options = options
      }
      send :include, InstanceMethods
      has_many :events, :as => :eventable, :dependent => :destroy
      after_save :record_events
    end
  end

  module InstanceMethods
    def record_events
      change_keys = changes.keys.select{ |key| self.class.eventable_options[:events].keys.include?(key) }
      raise change_keys.inspect if change_keys && !change_keys.empty?
    end
  end
end

ActiveRecord::Base.send :include, ActsAsEventable