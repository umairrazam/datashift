# Copyright:: (c) Autotelik Media Ltd 2015
# Author ::   Tom Statter
# Date ::     Feb 2015
# License::   MIT
#
# Details::   Read mappings and provide cache type services for source=>destination mappings
#
require 'erubis'

module DataShift

  module Importers

    class Configuration < DataShift::Configuration

      # Default is to stop processing once we hit a completely empty row. Over ride.
      # WARNING maybe slow, as will process all rows as defined by Excel
      # @param [Boolean]
      #
      attr_accessor :allow_empty_rows

      # List of headers/columns that are Mandatory i.e must be present in the inbound data
      #
      # @param [Array<#call>] List of headers/columns that are Mandatory
      # @return [Array<#call>]
      #
      attr_accessor :mandatory

      # Destroy failed objects - if object.save fails at any point destroy the current object - all or nothing
      # Default is true - database is cleaned up
      # @param [Boolean]
      #
      attr_accessor :destroy_on_failure

      # Stop processing and abort if any row fails to import
      # Default is false - row reported as failure but loading continues
      # @param [Boolean]
      #
      attr_accessor :abort_on_failure

      # Row containing headers - default is 0
      # @param [Integer]
      #
      attr_writer :header_row

      def initialize
        @mandatory = []
        @allow_empty_rows = false
        @abort_on_failure = false
        @destroy_on_failure = true
        @header_row = 0
      end

      # Custom Readers

      def header_row
        raise MissingHeadersError, "Minimum row for Headers is 0 - passed #{@header_row}" if @header_row.to_i < 0
        @header_row
      end


      # @return [DataShift::Importers::Configuration] DataShift's current configuration
      def self.call
        @configuration ||= Importers::Configuration.new
      end

      def self.reset
        @configuration = Importers::Configuration.new
      end

      # Set DataShift's configure
      # @param config [DataShift::Importers::Configuration]
      class << self
        attr_writer :configuration
      end

      # Modify DataShift's current Import configuration
      # ```
      # DataShift::Importers::Configuration.configure do |config|
      #   config.verbose = false
      # end
      # ```
      def self.configure
        yield call
      end

      # Modify DataShift's current Import configuration from an options hash

      def self.from_hash( options )
        DataShift::Importers::Configuration.configure do |config|
          config.mandatory = options[:mandatory] if(options[:mandatory])
        end
      end

    end
  end

end
