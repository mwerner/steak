require 'models/event'

class EventBot < Bot
  include CommandControl

  command     :event
  description 'An rsvp system for ad hoc events'
  username    'eventcjh'
  avatar      'http://i.imgur.com/mKSWziK.png'

  def bare(_ = nil)
    Event.upcoming.map do |event|
      "#{event.name} ##{event.key}\nWhen: #{event.occurs_at.strftime('%A, %b %d at %I:%M%P')}"
    end.join("\n")
  end

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
    @event ||= Event.where(key: incoming_message.arguments[0]).first
  end

  def event_message(event)
    compose_message.tap do |message|
      message.attach({
        title:      "#{event.name} ##{event.key}",
        text:       event.body,
        color:      '#7CD197',
        fallback:   "#{event.name} - ##{event.key}",
        thumb_url:  event.image_url,
        mrkdwn_in:  ['fields'],
        fields:     attachment_fields(event)
      })
    end
  end

  def rsvp_message(rsvp)
    'rsvp'
  end

  def no_event_message
    "No event found for ##{incoming_message.arguments[0]}"
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

  def attachment_fields(event)
    location_link = nil
    if event.location
      location_link = "<https://maps.google.com/maps?q=#{CGI.escape(event.location)}|#{event.location}>"
    end

    fields = [{
      title: 'Location',
      value: location_link,
      short: true
    },{
      title: 'Date',
      value: event.occurs_at.strftime('%A, %b %d at %I:%M%P'),
      short: true
    }]

    attending = event.rsvps.attending
    fields.push({
      title: ':white_check_mark: Going',
      value: user_list(attending.map(&:username))
    }) if attending.any?

    skipping = event.rsvps.skipping
    fields.push({
      title: ":thubs: Can't Go",
      value: user_list(skipping.map(&:username)),
      short: true
    }) if skipping.any?

    waiting = (Slack::USERNAMES - event.rsvps.map(&:username))
    fields.push({
      title: ":speech_balloon: Haven't responded",
      value: user_list(waiting),
      short: true
    }) if waiting.any?

    puts fields.inspect
    fields
  end

  def user_list(list)
    list.map!{|name| "@#{name}" }
    last = list.pop if list.length > 1

    result = list.join(', ')
    result += " and #{last}" if last
    result
  end
end
