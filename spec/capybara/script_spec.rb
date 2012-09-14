require "spec_helper"

describe "Steps" do  
  def run_steps(steps)
    script = Capybara::Script::Base.new(steps)
    script.run
    script
  end
  
  describe Capybara::Script::Steps::Visit do
    it "visits google" do
      script = run_steps([[:visit, {:url => "http://www.google.com"}]])
      script.session.current_url.should eq "http://www.google.com/"
    end
  end
end