require File.dirname(__FILE__) + '/test_helper.rb'

class ApplicationController < ActionController::Base
  def rescue_action(e)
    raise e
  end

  # Returns id of hypothetical current user
  def current_user
    153
  end
end

class FoosController < ApplicationController
  def create
    @foo = Foo.create params[:foo]
    head :ok
  end

  def update
    @foo = Foo.find params[:id]
    @foo.update_attributes params[:foo]
    head :ok
  end
end


class ActsAsEventableControllerTest < ActionController::TestCase #Test::Unit::TestCase
  def setup
    @controller = FoosController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new

    ActionController::Routing::Routes.draw do |map|
      map.resources :foos
    end
  end

  test 'create' do
    post :create, :foo => { :status => 'Flugel' }
    foo = assigns(:foo)
    assert_equal 1, foo.events.length
    assert_equal 153, foo.events.last.whodunnit.to_i
  end

  test 'update' do
    w = Foo.create :status => 'Duvel'
    assert_equal 1, w.events.length
    put :update, :id => w.id, :widget => { :status => 'Bugle' }
    foo = assigns(:foo)
    assert_equal 2, foo.events.length
    assert_equal 153, foo.events.last.whodunnit.to_i
  end

end

