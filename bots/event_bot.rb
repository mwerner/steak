require 'models/event'
require 'concerns/command_control'

class EventBot < Bot
  include CommandControl
  command     :event
  description 'An rsvp system for ad hoc events'
  username    'eventcjh'
  avatar      'http://i.imgur.com/mKSWziK.png'

  def bare
    Event.all.map(&:key)
  end

  def default(key)
    event = Event.where(key: key).first
    event_message(event)
  end

  def create(args)
    Event.where(key: args.first).first_or_initialize.tap do |event|
      event.update_args(args)
      event.save
    end

    'Event created'
  end

  def remove(args)
    event = Event.find(args.first)
    event.destroy
    "##{event.key} destroyed"
  end

  def list(args)
    bare
  end

  def update(args)
    Event.where(key: args.first).first_or_initialize.tap do |event|
      event.update_args(args)
      event.save
    end
    'Event Updated'
  end

  def rsvp(args)
    rsvp = event.rsvps
    rsvp_message(rsvp)
  end

  private

  def event_message(event)
    compose_message.tap do |message|
      message.attach({
        title:      'event', #"#{event.name} ##{event.tag}",
        text:       'result',
        color:      '#7CD197',
        fallback:   'fallback' #"#{event.name} - #{result}"
      })
    end
  end

  def rsvp_message(rsvp)
    'rsvp'
  end
end
