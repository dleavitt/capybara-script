require "capybara"
require 'active_support/core_ext/string/inflections'
require "active_support/callbacks"
require "capybara/script/version"
require "capybara/script/steps"

module Capybara
  class Script
    include ActiveSupport::Callbacks
    
    attr_accessor :steps, :steps_data, :session, :step, :step_index
    
    define_callbacks :script, :step
  
    def initialize(step_data)
      @steps_data = step_data
      # TODO: option to pass existing session?
      @session = Capybara::Session.new(:webkit)
      @steps = @steps_data.map { |name, params| Steps.definitions[name].new(session, params) }
    end

    def run
      run_callbacks :script do
        steps.each.with_index do |step, index|
          self.step = step
          self.step_index = index
          run_callbacks(:step) { @step.run }
        end
      end
    end
    
    class Abort < StandardError
      
    end
  end
end