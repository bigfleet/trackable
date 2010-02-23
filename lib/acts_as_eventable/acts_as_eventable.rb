module ActsAsEventable
  def self.included(base)
    base.send :extend, ClassMethods
  end

  module ClassMethods

    def acts_as_eventable(options)
      send :include, InstanceMethods
      has_many :events, :as => :eventable, :dependent => :destroy
      after_save :record_events
    end
  end

  module InstanceMethods
    def record_events
      raise "I was called!"
    end
  end
end

ActiveRecord::Base.send :include, ActsAsEventable