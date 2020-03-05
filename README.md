# StayNTouch

## Integrating the SNT Webhook API client into a Rails application

The SNT Webhook configuration API allows you to set the configuration options
for the client at the module level. Rails applications should add the following
to `config/initializers/snt_webhook.rb`:

```ruby
require 'snt/webhook'

SNT::Webhook.configure do |config|
  config.api_endpoint = ENV['IPC_WEBHOOK_ENDPOINT']
end
```

### Using environment variables

SNT Webhook will look for the value of its API endpoint in the `IPC_WEBHOOK_ENDPOINT`
environment variable. There is no default value so the environment variable must be set.

### Timeout

SNT Webhook defaults to 5 second timeouts for both open connection and read requests.
Read timeouts are retried once automatically for idempotent HTTP methods like GET, PUT,
and DELETE. To override the timeout values set:

```ruby
require 'snt/webhook'

SNT::Webhook.configure do |config|
  config.api_endpoint = ENV['IPC_WEBHOOK_ENDPOINT']
  config.open_timeout = 3
  config.read_timeout = 3
end
```

## SNT Webhook API client usage

Create an instance of the API client

```ruby
# Provide the required hotel chain uuid
client = SNT::Webhook::Client.new(chain_uuid: hotel_chain.uuid)
```

Passing configuration options to the API client

```ruby
client = SNT::Webhook::Client.new(
  chain_uuid: hotel_chain.uuid,
  api_endpoint: 'http://localhost:3000',
  read_timeout: 10
)
```

Make calls to the available methods. Responses are returned as hashes.

```ruby
client.webhooks.list
client.webhooks.create(params)
client.webhooks.retrieve(uuid)
client.webhooks.update(uuid, params)
client.webhooks.destroy(uuid)
client.webhooks.supporting_events
client.webhooks.delivery_types
```

## Local Development

In order to make changes on this gem and use it within another project you will need to do a few things to get started.

1. Checkout the github repo

2. Do a configure bundler to use a local git repo instead of the remote version

        bundle config local.snt /path/to/local/git/repository

3. Disable local branch checking in Bundler in order to provide updates to any local apps.

    **Note**: This will require you to manually check you pushed any committed changes to remote, otherwise other
apps will be pointing to a commit only existing in your local machine.
