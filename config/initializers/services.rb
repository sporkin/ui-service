Rails.application.config.before_initialize do
  config = YAML.load(File.read(File.join(Rails.root, "/config/services.yml")))
  SERVICES = config[Rails.env]
end

EventMachine.next_tick do
  channel = AMQP::Channel.new(AMQP.connect(:host => SERVICES["RABBIT_MQ_HOST"]))

  AUTH_SERVICE_EXCHANGER = channel.fanout("auth-service")
  UI_SERVICE_EXCHANGER = channel.fanout("ui-service")

  queue = channel.queue("user_created", :auto_delete => false).bind(AUTH_SERVICE_EXCHANGER)
  queue.subscribe(:ack => true) do |header, attributes|
    attributes = JSON.parse(attributes) rescue {}
    user = User.create(:uuid => attributes["uuid"])
    header.ack
  end
end
