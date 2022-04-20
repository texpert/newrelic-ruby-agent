# encoding: utf-8
# This file is distributed under New Relic's license terms.
# See https://github.com/newrelic/newrelic-ruby-agent/blob/main/LICENSE for complete details.

require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'test_helper'))

module ::The
  class Example
    def self.class_method; end
    def instance_method; end
  end
end

class NewRelic::Agent::MethodTracerHelpersTest < Minitest::Test
  # TODO: trace_execution_scoped should have test coverage

  def test_obtains_a_class_name_from_a_singleton_class_string
    name = NewRelic::Agent::MethodTracerHelpers.klass_name(The::Example.singleton_class.to_s)
    assert_equal 'The::Example', name
  end

  def test_returns_nil_if_a_name_cannot_be_determined
    name = NewRelic::Agent::MethodTracerHelpers.klass_name('StrawberriesAndSashimi')
    assert_equal nil, name
  end

  def test_do_not_gather_code_info_when_disabled_by_configuration
    with_config(:'code_level_metrics.enabled' => false) do
      info = NewRelic::Agent::MethodTracerHelpers.code_information(The::Example, :class_method)
      assert_equal NewRelic::EMPTY_HASH, info
    end
  end

  def test_uses_cache_if_an_object_and_method_combo_have_already_been_seen
    object = The::Example.new
    method_name = :instance_method
    cached_info = 'Badger'
    cache = {"#{object.object_id}#{method_name}" => cached_info}
    NewRelic::Agent::MethodTracerHelpers.instance_variable_set(:@code_information, cache)
    info = NewRelic::Agent::MethodTracerHelpers.code_information(object, method_name)
    assert_equal cached_info, info
  end

  def test_provides_accurate_info_for_a_class_method
    info = NewRelic::Agent::MethodTracerHelpers.code_information(The::Example.singleton_class, :class_method)
    assert_equal({filepath: __FILE__,
      lineno: 9,
      function: :class_method,
      namespace: 'The::Example'},
      info)
  end

  def test_provides_accurate_info_for_an_instance_method
    info = NewRelic::Agent::MethodTracerHelpers.code_information(::The::Example, :instance_method)
    assert_equal({filepath: __FILE__,
      lineno: 10,
      function: :instance_method,
      namespace: 'The::Example'},
      info)
  end

  def test_provides_accurate_info_for_an_anonymous_method
    klass = Class.new do
      def an_instance_method; end
    end
    info = NewRelic::Agent::MethodTracerHelpers.code_information(klass, :an_instance_method)
    assert_equal({filepath: __FILE__,
      lineno: 64,
      function: :an_instance_method,
      namespace: '(Anonymous)'},
      info)
  end
end
