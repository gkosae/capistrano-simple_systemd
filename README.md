# capistrano-simple_systemd [![Gem Version](https://badge.fury.io/rb/capistrano-simple_systemd.svg)](https://badge.fury.io/rb/capistrano-simple_systemd)

Capistrano tasks to control mutiple services with systemd

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'capistrano-simple_systemd'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capistrano-simple_systemd

## Usage

Add this line to your Capfile:

```ruby
require "capistrano/simple_systemd"
```

Service files are defined as ERB templates ending with `.service.erb` in `config/systemd`. <br>
Sample erb template
```
[Unit]
Description=SMS Service
After=network.target

[Service]
Type=simple
User=deploy
Environment=RACK_ENV=<%= fetch(:stage) %>
WorkingDirectory=<%= current_path %>
ExecStart=<%= "#{fetch(:home_dir)}/.rvm/bin/rvm #{fetch(:rvm_ruby_version)} do bundle exec #{current_path}/bin/sms_service"%>
TimeoutSec=10
Restart=always
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=sms-service

[Install]
WantedBy=multi-user.target
```
PLEASE NOTE: Currently only files with the  `.service.erb` extension are considered as service file templates. Others like `.target.erb` aren't supported yet

The following tasks are provided out of the box
```ruby
cap systemd:reload-daemons # run sudo systemctl daemon-reload
cap systemd:upload         # upload all provided service files
cap systemd:remove         # remove all provided service files
cap systemd:enable         # enable all provided service files
cap systemd:disable        # disable all provided service files
```

The following tasks will be created for each service template detected in the `config/systemd` directory

```ruby
cap systemd:{service}:disable
cap systemd:{service}:enable
cap systemd:{service}:reload
cap systemd:{service}:reload-or-restart
cap systemd:{service}:restart
cap systemd:{service}:start
cap systemd:{service}:stop
cap systemd:{service}:upload
cap systemd:{service}:remove
```
Where `service` is the base name of the service template. <br>
For example, placing `puma.service.erb` in the template directory will yield the following tasks
```ruby
cap systemd:puma:disable
cap systemd:puma:enable
cap systemd:puma:reload
cap systemd:puma:reload-or-restart
cap systemd:puma:restart
cap systemd:puma:start
cap systemd:puma:stop
cap systemd:puma:upload
cap systemd:puma:remove
```

Run 
```ruby
cap {stage} systemd:upload
```
Or
```ruby
cap {stage} setup
```

to compile and upload the service files. Service files will be prefixed with whichever value is in `service_file_prefix` and uploaded to `/etc/systemd/system`. The variable `service_file_prefix` by default is set to whatever is in the `application` configuration variable. <br>So if `application` is set to `paypoint` then `puma.service.erb` will be uploaded to `/etc/systemd/system/paypoint-puma.service`. <br>
`service_file_prefix` can be configured. E.g.
```ruby
set :service_file_prefix, 'paypoint-app'
```

Services are enabled after upload by invoking `systemd:{service}:enable`. This behaviour can be disabled by setting `enable_services_after_upload` to false.
```ruby
set :enable_services_after_upload, false
```

## Contributing
All contributions are welcome. Improvements are especially welcome. To contribute
1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
