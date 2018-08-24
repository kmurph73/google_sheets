# frozen_string_literal

module GoogleSheets
  class Spreadsheet
    # the spreadsheet key
    # @return [String]
    attr_reader :key

    def initialize service, key
      @key = key
      @service = service
      load_spreadsheet
    end

    # loads the spreadsheet from google sheets
    def load_spreadsheet
      @sheets = nil
      @spreadsheet = @service.get_spreadsheet(@key)
      @properties = @spreadsheet.properties.to_h
    end

    # reloads the spreadsheet, effectively uncaching everything
    alias refresh! load_spreadsheet

    # @return [Array(Sheet)]
    def sheets
      @sheets ||= @spreadsheet.sheets.map do |sheet|
        Sheet.new(@service, sheet, self)
      end
    end

    # HT this SO answer: https://stackoverflow.com/a/49886382/548170
    # @return [Sheet]
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

    # Returns a GoogleDrive::Worksheet with the given title in the spreadsheet.
    #
    # Returns nil if not found. Returns the first one when multiple worksheets
    # with the title are found.
    def sheet_by_title(title)
      sheets.find { |ws| ws.title == title }
    end

    private

    def append_to_sheet title, values
      # The A1 notation of a range to search for a logical table of data.
      # Values will be appended after the last row of the table.
      range = title

      request_body = Google::Apis::SheetsV4::ValueRange.new(values: values)

      response = @service.append_spreadsheet_value(@key, range, request_body, value_input_option: 'RAW')
    end
  end
end
