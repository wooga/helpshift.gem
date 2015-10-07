# Helpshift.Gem

Gem for communicating with the api.helpshift.com API.

# Usage

## Configure

1. Install https://github.com/wooga/helpshift.gem
2. Configure the gem with your credentials

```
config = Helpshift.configuration
config.customer_domain ="___your_customer_domain___"
config.api_key = "___your_api_key___"
```
## Get all Applications
```
App.all
```
## Get a specific Applications
```
App.find(___your_app_publish_id___)
```
## Create a new issue
```
issue = Helpshift::Issue.new

issue.email ="xoxo@xoxo.com"
issue.title = "test issue title"
issue.message_body = "test issue message body"
issue.app_id="___your_app_id___"

issue.platform_type = "android"

issue.tags = [ "test_tag1", "test_tag2" ]
issue.meta = { "meta-data-item1" => "bla1", "meta-data-item2" => "bla2" }

issue.create

```

4. Caveats

* When adding tags to your issue, make sure they were predefined in the webinterface before.
*


## Contributing to pplgem

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.
