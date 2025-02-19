# encoding: utf-8
# This file is distributed under New Relic's license terms.
# See https://github.com/newrelic/newrelic-ruby-agent/blob/main/LICENSE for complete details.
# frozen_string_literal: true

module NewRelic
  module Agent
    module GuidGenerator
      module_function

      # This method intentionally does not use SecureRandom, because it relies
      # on urandom, which raises an exception in MRI when the interpreter runs
      # out of allocated file descriptors.
      # The guids generated by this method may not be _secure_, but they are
      # random enough for our purposes.
      def generate_guid(length = 16)
        guid = rand(16**length).to_s(16)
        guid.length < length ? guid.rjust(length, "0") : guid
      end
    end
  end
end
