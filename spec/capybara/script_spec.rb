require "spec_helper"

describe Capybara::Script do
  describe "callbacks" do
    before do
      class TestScript < Capybara::Script
        set_callback :script, :around,  :around_script
        set_callback :step,   :around,  :around_step
        
        def around_script
          yield
        end
        
        def around_step
          yield
        end
      end
      
      @script = TestScript.new([[:visit, {:url => "http://www.google.com/"}]])
      
      
    end
    
    it "calls the script callback" do
      @script.class.set_callback :script, :before do
        step.should == nil
      end
      
      @script.class.set_callback :script, :after do
        step.should == steps[-1]
      end
      
      @script.class.set_callback :script, :around do |&block|
        step.should == nil
        block.yield
        step.should == steps[-1]
      end
      
      @script.run
    end
    
    it "calls the step callback" do
      @script.class.set_callback :step, :before do
        session.current_url.should == ""
        step.should == steps[0]
      end
      
      @script.class.set_callback :step, :after do
        session.current_url.should == "http://www.google.com/"
        step.should == steps[0]
      end
      
      @script.class.set_callback :step, :around do |&block|
        session.current_url.should == ""
        block.yield
        session.current_url.should == "http://www.google.com/"
      end
      
      @script.run
    end
  end
end