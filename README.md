[google-drive-ruby]([https://github.com/gimite/google-drive-ruby), a great gem, doesn't support Google's v4 Drive API.  As a result, I seemed to encounter rate limiting errors fairly quickly.

Since I only ever used that gem for creating/reading spreadsheets, I created this simple gem for just that, but using the v4 API.

* [Installing](#installing)
* [Gettting started](#use)
* [Github](http://github.com/shmay/google_sheets)

## <a name="installing">Installing</a>

Add this line to your application's Gemfile & `bundle install`:

```ruby
gem 'google_sheets'
```

Or install it yourself:

```
$ gem install google_drive
```

## <a name="use">Getting started</a>

### Authorization

# TODO: add links ok?
The authorization process is taken from Google's [own tutorial](https://developers.google.com/sheets/api/quickstart/ruby#step_3_set_up_the_sample).

Please create a project and setup the GSheets API, as detailed [in step 1 of that tutorial](https://developers.google.com/sheets/api/quickstart/ruby#step_1_turn_on_the_api_name).

You'll download a `client_secret.json` that will contain a `client_id` and `client_secret`

I recommend storing them in Rails 5.2's encrypted credentials.  So the final will result will look something:

``` ruby
client_id = Rails.application.credentials[:client_id]
client_secret = Rails.application.credentials[:client_secret]

session = GoogleSheets::Session.start_session(
  client_id: client_id,
  client_secret: client_secret
)
```

Or store them in an environment variable: `ENV['client_id']`
