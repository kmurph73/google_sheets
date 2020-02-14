# frozen_string_literal

require 'google_sheets/session'

module GoogleSheets
  # #strip cells?
  class << self
    attr_accessor :strip_all_cells
  end
end
