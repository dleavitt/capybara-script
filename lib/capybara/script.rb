require "capybara"
require 'active_support/core_ext/string/inflections'
require "active_support/callbacks"
require "capybara/script/version"
require "capybara/script/steps"

module Capybara
  class Script
    include ActiveSupport::Callbacks
    
    attr_accessor :steps, :steps_data, :session, :step, :step_index, :error
    
    define_callbacks :script, :step, :cancel
  
    def initialize(step_data, options = {})
      @steps_data = step_data
      # TODO: option to pass existing session?
      @session = options[:session] || Capybara::Session.new(:webkit)
      
      @steps = @steps_data.map { |name, params| Steps.definitions[name].new(session, params) }
    end

    def run
      run_callbacks :script do
        begin
          steps.each.with_index do |step, index|
            self.step = step
            self.step_index = index
            run_callbacks(:step) { @step.run }
          end
        rescue Cancel => ex
          @error = ex
          run_callbacks :cancel
        end
      end
    end
    
    class Cancel < StandardError
      
    end
  end
end