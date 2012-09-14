module Capybara
  module Script  
    class Base
      attr_accessor :steps, :session
    
      def initialize(steps)
        self.steps = steps
        
        # TODO: option to pass existing session?
        self.session = Capybara::Session.new(:webkit)
      end
  
      def run
        steps.each.with_index do |step_data, index|
          step_name, step_params = step_data
          step = Steps.definitions[step_name].new(session, step_params)
      
          around_step(step, index) do
            step.run
          end
      
        end
      end
  
      def around_step(step, index)
        yield
      end
    end
  end
end