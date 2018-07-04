module GoogleSheets
  class Spreadsheet
    attr_reader :key

    def initialize service, key
      @key = key
      @service = service
      @spreadsheet = service.get_spreadsheet(key)
      @properties = @spreadsheet.properties.to_h
    end

    def sheets
      @sheets ||= @spreadsheet.sheets.map do |sheet|
        Sheet.new(@service, sheet, self)
      end
    end

    def add_sheet title, values: []
      add_sheet_request = Google::Apis::SheetsV4::AddSheetRequest.new
      add_sheet_request.properties = Google::Apis::SheetsV4::SheetProperties.new
      add_sheet_request.properties.title = title

      batch_update_spreadsheet_request = Google::Apis::SheetsV4::BatchUpdateSpreadsheetRequest.new
      batch_update_spreadsheet_request.requests = Google::Apis::SheetsV4::Request.new

      batch_update_spreadsheet_request_object = [ add_sheet: add_sheet_request ]
      batch_update_spreadsheet_request.requests = batch_update_spreadsheet_request_object

      response = @service.batch_update_spreadsheet(@key, batch_update_spreadsheet_request)

      resp = append_to_sheet(title, values) if values&.any?

      add_sheet = response.replies[0].add_sheet

      sheet = Sheet.new(@service, add_sheet, self)

      sheet.values = values if values&.any?

      self.sheets << sheet

      sheet
    end

    def append_to_sheet title, values
      # The A1 notation of a range to search for a logical table of data.
      # Values will be appended after the last row of the table.
      range = title

      request_body = Google::Apis::SheetsV4::ValueRange.new(values: values)

      response = @service.append_spreadsheet_value(@key, range, request_body, value_input_option: 'RAW')
    end

    def self.add_and_append sheet_name, values
      add_worksheet sheet_name
      append_to_sheet sheet_name, values
    end
  end
end
