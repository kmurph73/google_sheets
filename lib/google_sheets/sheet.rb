module GoogleSheets
  class Sheet
    attr_reader :properties, :title
    attr_writer :values

    def initialize service, sheet, spreadsheet
      @service = service
      @spreadsheet = spreadsheet
      @sheet = sheet
      @properties = sheet.properties.to_h
      @title = @properties[:title]
    end

    def id
      @properties[:sheet_id]
    end

    def values
      @values ||= @service.get_spreadsheet_values(@spreadsheet.key, @title).values
    end

    def delete!
      delete_sheet_request = Google::Apis::SheetsV4::DeleteSheetRequest.new
      delete_sheet_request.sheet_id = self.id

      batch_update_spreadsheet_request = Google::Apis::SheetsV4::BatchUpdateSpreadsheetRequest.new
      batch_update_spreadsheet_request.requests = Google::Apis::SheetsV4::Request.new

      batch_update_spreadsheet_request_object = [ delete_sheet: delete_sheet_request ]
      batch_update_spreadsheet_request.requests = batch_update_spreadsheet_request_object

      response = @service.batch_update_spreadsheet(@spreadsheet.key, batch_update_spreadsheet_request)

      @spreadsheet.sheets.delete(self)

      self
    end
  end
end
