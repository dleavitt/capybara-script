require "spec_helper"

describe Capybara::Script do
  describe "callbacks" do
    before do
      class TestScript < Capybara::Script
        set_callback :script, :around,  :around_script
        set_callback :step,   :around,  :around_step
        set_callback :cancel, :after,   :after_cancel
        
        def around_script
          yield
        end
        
        def around_step
          yield
        end
        
        def after_cancel
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
    
    describe "cancel" do
      before do
        @script.class.set_callback :step, :after do
          raise Capybara::Script::Cancel.new
        end
      end
      
      it "sets an error on the script" do
        @script.error.should be_nil
        @script.run
        @script.error.should_not be_nil
      end
      
      it "calls the cancel callback" do
        @script.should_receive(:after_cancel)
        @script.run
      end
    end
  end
  
  describe Capybara::Script::Steps::Check do
    it "checks the box" do
      script = run_steps [
        [:visit,      {:url => "http://dleavitt-test.s3.amazonaws.com/within_spec.html"}],
        [:check,      {:selector => "Checkbox Test"}],
        [:click_on,   {:selector => "submit_checkbox"}],
      ]
      
      script.session.current_url.split('?')[-1].should eq "checkbox_test=1"
    end
  end
end