module Yaffle
  def self.included(base)
    base.send :extend, ClassMethods
  end

  module ClassMethods

    def acts_as_eventable
      send :include, InstanceMethods
    end
  end

  module InstanceMethods
    
  end
end