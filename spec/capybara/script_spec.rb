require "spec_helper"

describe Capybara::Script do
  describe "callbacks" do
    before do
      @script = Capybara::Script.new([[:visit, {:url => "http://www.google.com/"}]])
    end
    
    it "calls the script callback" do
      @script.class.set_callback :script, :before do
        step.should == nil
      end
      
      @script.class.set_callback :script, :after do
        step.should == steps[-1]
      end
      
      @script.run
    end
    
    it "calls the step callback" do
      @script.class.set_callback :step, :before do
        session.current_url.should == ""
        step.should == steps[0]
      end
      
      @script.class.set_callback :script, :after do
        session.current_url.should == "http://www.google.com/"
        step.should == steps[0]
      end
      
      @script.run
    end
  end
end