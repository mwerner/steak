require 'models/event'

class Rsvp < ActiveRecord::Base
  belongs_to :event

  scope :attending, -> { where(attending: true) }
  scope :skipping, -> { where(attending: false) }
end
