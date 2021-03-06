$APP_ENV = "test"
require 'rubygems'
require 'ruby-debug'
require File.dirname(__FILE__) + '/../config'
require 'test/unit'
require 'rr'

class Test::Unit::TestCase
  include RR::Adapters::TestUnit
end

def context(*args, &block)
  return super unless (name = args.first) && block
  require 'test/unit'
  klass = Class.new(Test::Unit::TestCase) do
    define_method(:teardown) do
      MongoMapper.database.collections.each do |coll|
        coll.remove
      end
    end
    def self.test(name, &block)
      define_method("test_#{name.gsub(/\W/,'_')}", &block) if block
    end
    def self.xtest(*args) end
    def self.setup(&block) define_method(:setup, &block) end
    def self.teardown(&block) define_method(:teardown, &block) end
    def clear(*klasses) klasses.each {|klass| klass.delete_all } end
  end
  (class << klass; self end).send(:define_method, :name) { name.gsub(/\W/,'_') }
  klass.class_eval &block
end
