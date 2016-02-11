class Event < ActiveRecord::Base
  has_many :rsvps

  def self.update_args(args)
    attrs = args.split('|')
    event = Event.find_by_key(attrs.first)

    event ||= create({
      key: attrs.first
    })
  end
end
