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

      values = sheet.values

      expect(values).to eq([%w(one two), %w(three four)])

      values = [[1,2],[3,4]]

      new_sheet_name = 'yoyo10'

      sheet = spreadsheet.add_sheet(new_sheet_name, values: values)

      expect(sheet.values).to eq(values)

      expect(spreadsheet.sheets.map(&:title)).to eq(existing_sheet_names + [new_sheet_name])

      sheet.delete!

      expect(spreadsheet.sheets).to_not include(sheet)

      # dememoize the sheets
      spreadsheet.sheets = nil
    end
  end
end
