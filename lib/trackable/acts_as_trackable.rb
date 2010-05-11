module ActsAsTrackable
  def self.included(base)
    base.send :extend, ClassMethods
    base.instance_eval{
      class_inheritable_accessor :eventable_options
    } 
  end

  module ClassMethods

    def trackable(options={})
      instance_eval{
        self.eventable_options = options
      }
      send :include, InstanceMethods
      has_many :events, :as => :eventable, :dependent => :destroy, :order => "created_at desc"
      send options[:on] ? :"after_#{options[:on]}" : :after_save, :record_events
    end
  end

  module InstanceMethods
    def record_events
      active_keys = changes.keys.reject{ |key| %w{id created_at created_on updated_at updated_on}.include?(key)}
      active_keys.map do |key|
        old_val, new_val = changes[key]
        attrs = Event.attributes_from(self, key, old_val, new_val)
        events.create(attrs) if attrs
      end
    end
  end
end

ActiveRecord::Base.send :include, ActsAsTrackable