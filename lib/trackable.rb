# Trackable
require 'trackable/acts_as_trackable'
require 'trackable/event'

module Trackable
  @@whodunnit = nil

  def self.included(base)
    base.before_filter :set_whodunnit
  end

  def self.whodunnit
    @@whodunnit.respond_to?(:call) ? @@whodunnit.call : @@whodunnit
  end

  def self.whodunnit=(value)
    @@whodunnit = value
  end

  private

  def set_whodunnit
    @@whodunnit = lambda {
      self.send :current_user rescue nil
    }
  end
end

ActionController::Base.send :include, Eventable