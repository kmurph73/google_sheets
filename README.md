[google-drive-ruby](https://github.com/gimite/google-drive-ruby), a great gem, doesn't support Google's v4 Drive API.  As a result, I seem to encounter rate limiting errors fairly quickly.

Since I only ever used that gem for creating/reading spreadsheets, I created this simple gem for just that, but using the v4 API.

* [Installing](#installing)
* [Getting started](#getting-started)
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

### Authorization

The authorization process is taken from Google's [own tutorial](https://developers.google.com/sheets/api/quickstart/ruby#step_3_set_up_the_sample).

You'll need to create a project and enable the GSheets API, as detailed [in step 1 of that tutorial](https://developers.google.com/sheets/api/quickstart/ruby#step_1_turn_on_the_api_name).

You'll download a `client_secret.json` that will contain a `client_id` and `client_secret`

I recommend using Rails 5.2's encrypted credentials to store the id & secret.  So the final will result will look something like:

``` ruby
client_id = Rails.application.credentials[:client_id]
client_secret = Rails.application.credentials[:client_secret]

session = GoogleSheets::Session.start_session(
  client_id: client_id,
  client_secret: client_secret
)
```

Or store them in an environment variable, EG: `ENV['client_id']`

This will prompt you to authorize the app in the browser.  Once completed, you'll notice a `token.yaml` in your cwd.  If you'd like the file to be placed elsewhere, there's a `token_path` parameter that you can pass into `start_session`, EG:

``` ruby
session = GoogleSheets::Session.start_session(
  client_id: client_id,
  client_secret: client_secret,
  token_path: './tmp'
)
```

### Getting Started

Once you're authorized, you can read, create, and delete sheets within a spreadsheet.

``` ruby
session = GoogleSheets::Session.start_session(
  client_id: ENV['test_client_id'],
  client_secret: ENV['test_client_secret']
)

spreadsheet = session.spreadsheet_from_key '[your spreadsheet key]'

spreadsheet.sheets.map &:title
# => ['Sheet1', 'yoyo1']

sheet1 = spreadsheet.sheets[0]

sheet1.values
# => [['one','two'], ['three', 'four']

values = [[1,2],[3,4]]

sheet2 = spreadsheet.add_sheet('what', values: values)

spreadsheet.sheets.map &:title

# => ['Sheet1', 'yoyo1', 'what']

# this will delete the sheet!!!
sheet.delete!

spreadsheet.sheets.map &:title
# => ['Sheet1', 'yoyo1', 'what']
```

Or just look at [the spec](spec/test_all_the_things_spec.rb) to see it in action.
