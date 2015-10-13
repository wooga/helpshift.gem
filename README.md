# Helpshift.Gem

[![Build Status](https://travis-ci.org/stephanlindauer/helpshift.gem.svg?branch=master)](https://travis-ci.org/stephanlindauer/helpshift.gem)

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
Helpshift::App.all
```
## Get a specific Applications
```
Helpshift::App.find(___your_app_publish_id___)
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

# Caveats

* When adding tags to your issue, make sure they were predefined in the web interface before. If you dont, they won't show up.
