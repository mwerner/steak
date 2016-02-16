require 'models/event'

class EventBot < Bot
  include CommandControl

  command     :event
  description 'An rsvp system for ad hoc events'
  username    'eventcjh'
  avatar      'http://i.imgur.com/mKSWziK.png'

  def bare(_ = nil)
    Event.all.map(&:key)
  end
  alias_method :list, :bare

  def default(args)
    return no_event_message unless event
    event_message(event)
  end

  def create(args)
    return "Event key already taken" if event

    record = Event.new.tap do |event|
      event.assign_attributes(arguments)
      event.save
    end

    "Event created: ##{record.key}"
  end

  def remove(args)
    return no_event_message unless event

    event.destroy
    "##{event.key} removed"
  end

  def update(args)
    return no_event_message unless event

    _, _, attribute, *values = incoming_message.arguments
    event.assign_attributes(attribute => values.join(' '))
    event.save
    "##{event.key} Updated. Set #{attribute} to #{values.join(' ')}"
  end

  def rsvp(args)
    rsvp = event.rsvps
    rsvp_message(rsvp)
  end

  private

  def event
    @event ||= Event.where(key: incoming_message.arguments[1]).first
  end

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

  def no_event_message
    "No event found for ##{incoming_message.arguments[1]}"
  end

  def arguments
    @arguments ||= begin
      values = incoming_message.args_string.split('|')
      key, name, date, body, loc, img, link = values
      {
        key: key,
        name: name,
        body: body,
        location: loc,
        image_url: img,
        occurs_at: date
      }
    end
  end
end
