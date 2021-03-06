module Capybara
  class Script
    module Steps
      def self.definitions
        @step_definitions ||= {}
      end
    
      class Base
        attr_accessor :session, :params, :message
      
        def self.register_step(step_name = nil)
          step_name ||= self.name.split("::")[-1].underscore.to_sym
          Steps.definitions[step_name] = self
        end

        def initialize(session, params = {})
          self.session = session
          self.params = params
        end

        def run
          raise "run must be defined on child"
        end
      end
    
      class Wait < Base
        register_step
      
        def run
          sleep(params[:seconds])
        end
      end
    
      class Action < Base  
      end
    
      class Visit < Action
        register_step
      
        def run
          session.visit params[:url]
        end
      end
      
      class DOMAction < Action
        def run
          begin
            if scope = params.delete(:within) 
              session.within(scope) { do_run() } 
            else 
              do_run() 
            end
          rescue Capybara::ElementNotFound => ex
            false
          end
        end

        def do_run
          raise "do_run must be defined on child"
        end
      end

      class FillIn < DOMAction
        register_step

        def do_run
          @session.fill_in params[:selector], :with => params[:value]
        end
      end

      class ClickOn < DOMAction
        register_step

        def do_run
          @session.click_on params[:selector]
        end
      end
      
      class Check < DOMAction
        register_step
        
        def do_run
          @session.check params[:selector]
        end
      end
      
      class Uncheck < DOMAction
        register_step
        
        def do_run
          @session.uncheck params[:selector]
        end
      end
      
      class Choose < DOMAction
        register_step
        
        def do_run
          @session.choose params[:selector]
        end
      end
      
      class Select < DOMAction
        register_step
        
        def do_run
          @session.select params[:value], :from => params[:selector]
        end
      end
      
      class Unselect < DOMAction
        register_step
        
        def do_run
          @session.unselect params[:value], :from => params[:selector]
        end
      end
    end
  end
end