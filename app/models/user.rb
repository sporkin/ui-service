class User < ActiveRecord::Base
  attr_accessible :uuid

  after_create :publish_user_record_sync_event

  def publish_user_record_sync_event
    message = {:uuid => uuid}
    UI_SERVICE_EXCHANGER.publish message.to_json, :routing_key => "*"
  end
end
