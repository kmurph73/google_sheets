require 'spec_helper'
require 'google_sheets'

RSpec.describe GoogleSheets::Session do
  describe 'self.start_session' do
    it 'starts session, can add & delete sheets' do
      session = GoogleSheets::Session.start_session(
        client_id: ENV['test_client_id'],
        client_secret: ENV['test_client_secret'],
        token_path: './tmp'
      )

      spreadsheet = session.spreadsheet_from_key '13kc3I2yn0jE-Fg-cAeGl3EvP7lAkxpqvZq6a7pQZJwY'

      existing_sheet_names = spreadsheet.sheets.map &:title

      sheet = spreadsheet.sheets[0]

      expect(sheet.values).to eq([%w(one two), %w(three four)])

      values = [[1,2],[3,4]]

      new_sheet_name = 'yoyo10'

      sheet = spreadsheet.add_sheet(new_sheet_name, values: values)

      expect(sheet.values).to eq(values)

      new_sheet_names = existing_sheet_names + [new_sheet_name]

      expect(spreadsheet.sheets.map(&:title)).to eq(new_sheet_names)

      # dememoize the sheets
      spreadsheet.refresh!

      # hit the api again to ensure operation actually succeeded
      expect(spreadsheet.sheets.map(&:title)).to eq(new_sheet_names)

      sheet = spreadsheet.sheets[-1]

      expect(sheet.title).to eq(new_sheet_name)

      expect(sheet.values).to eq(values)

      sheet.delete!

      # same deal
      spreadsheet.refresh!

      expect(spreadsheet.sheets.map(&:title)).to eq(existing_sheet_names)
    end
  end
end
