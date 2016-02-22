require 'models/rsvp'
class Event < ActiveRecord::Base
  has_many :rsvps

  def self.upcoming
    where("occurs_at >= '#{Time.now.to_s(:sql)}'")
  end
end
