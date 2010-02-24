class Foo < ActiveRecord::Base
  trackable :events =>{
    :no_homers => {true => "Homers have been barred.", false => "Homers have been allowed."},
    :custom_status => {:message => Proc.new {|n| "The value of a custom string field changed to #{n}" }},
    :custom_bar_id => {:message => Proc.new{|n| "Active Bar set to #{n}"}}
  }, :exclude => :do_not_track
  belongs_to :bar, :class_name => "Bar"
  belongs_to :custom_bar, :class_name => "Bar"
end

class Bar < ActiveRecord::Base
  def to_s
    name
  end
end