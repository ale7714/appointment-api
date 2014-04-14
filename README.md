API Appointment
===============

#### Simple API to *CREATE*, *SHOW*, *UPDATE*, *DELETE* and *LIST* appointments ####

Usage
===============

## API Endpoint ##

http://appointments-api.herokuapp.com/api/v1/

## Resource URLs ##

* /appointments
* /appointments/{APPOINTMENT_ID}

## Examples ##

* List appointments
```cURL
curl --request get http://appointments-api.herokuapp.com/api/v1/appointments
```
* Post ppointments
```cURL
curl --request POST http://appointments-api.herokuapp.com/api/v1/appointments 
--data appointment[first_name]="Brcue" --data appointment[last_name]="Wayne" 
--data appointment[start_time]="2014-04-15T15:15:00" --data appointment[end_time]="2014-04-15T15:55:00" 
--data appointment[comment]="top secret"
```

Technical information
===============

* Ruby 2.0.0p247
* Rails 4.0.2
* PostgreSQL 9.3.4

Testing
===============

* rspec-rails: [rspec/rspec-rails](https://github.com/rspec/rspec-rails)
* shoulda-matchers: [thoughtbot/shoulda-matchers](https://github.com/thoughtbot/shoulda-matchers)
* fabrication: [paulelliott/fabrication](https://github.com/paulelliott/fabrication)

Specs can be found under *spec/* folder and can be execute with the following command:
```ruby
bundle exec rspec
```

Documentation
===============

Documentation can be found under *doc/* folder