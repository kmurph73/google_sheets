# frozen_string_literal

module GoogleSheets
  class Sheet
    # [Google::Apis::SheetsV4::SheetProperties](https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/SheetsV4/SheetProperties) in hash form
    # @return [Hash]
    attr_reader :properties
    # title of the sheet
    # @return [String]
    attr_reader :title
    attr_writer :values

    def initialize service, sheet, spreadsheet
      @service = service
      @spreadsheet = spreadsheet
      @sheet = sheet
      @properties = sheet.properties.to_h
      @title = @properties[:title]
    end

    # The internal ID of the sheet. From Google.
    # @return [Integer]
    def id
      @properties[:sheet_id]
    end

    # Returns an Array of string values, EG: [['one', 'two'], ['three', 'four']]
    # @return [Array(String)]
    def values
      @values ||= @service.get_spreadsheet_values(@spreadsheet.key, @title).values
    end

    # Deletes a sheet from a spreadsheet
    # @return [Sheet]
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

    # Converts the spreadsheet to an array of hashes, using the top row as the keys
    #
    # EG `[['name', 'age'], ['john', '20']] => [{name: 'john', age: '20'}]`
    # @return [Array(Hash)]
    def to_json
      top_row = values[0].map &:to_sym
      hashify_data(values[1..-1], top_row)
    end

    private

    def hashify_data csv, top_row
      csv.map do |arr|
        hash = {}

        top_row.each_with_index do |attr, index|
          hash[attr.to_sym] = utf8ify(arr[index])
        end

        hash
      end
    end

    def utf8ify val
      if val.class == String && val.encoding.to_s != 'UTF-8'
        val = val.dup.force_encoding('utf-8')
      end

      val
    end

  end
end
