module Howitzer
  ##
  #
  # Data can be stored in memory using this class
  #
  module Cache
    SPECIAL_NS_LIST = [:cloud].freeze
    @data ||= {}

    class << self
      attr_reader :data

      # Saves data into memory. Marking by a namespace and a key
      #
      # @param ns [String] a namespace
      # @param key [String] a key that should be uniq within the namespace
      # @param value [Object] everything you want to store in Memory
      # @raise [StandardError] if the namespace missing

      def store(ns, key, value)
        check_ns(ns)
        @data[ns][key] = value
      end

      # Gets data from memory. Can get all namespace or single data value in namespace using key
      #
      # @param ns [String] a namespace
      # @param key [String] key that isn't necessary required
      # @return [Object, Hash] all data from the namespace if the key is ommited, otherwise returs
      #   all data for the namespace
      # @raise [StandardError] if the namespace missing

      def extract(ns, key = nil)
        check_ns(ns)
        key ? @data[ns][key] : @data[ns]
      end

      # Deletes all data from a namespace
      #
      # @param ns [String] a namespace

      def clear_ns(ns)
        init_ns(ns)
      end

      # Deletes all namespaces with data
      #
      # @param exception_list [Array] a namespace list for excluding

      def clear_all_ns(exception_list = SPECIAL_NS_LIST)
        (@data.keys - exception_list).each { |ns| clear_ns(ns) }
      end

      private

      def check_ns(ns)
        if ns
          init_ns(ns) if ns_absent?(ns)
        else
          Howitzer::Log.error 'Data storage namespace can not be empty'
        end
      end

      def ns_absent?(ns)
        !@data.key?(ns)
      end

      def init_ns(ns)
        @data[ns] = {}
      end
    end
  end
end
