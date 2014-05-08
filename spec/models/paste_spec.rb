require 'spec_helper'

describe Paste do
   before do
       @paste = Paste.new(title: "mypaste",
            content: "not much content",
            expiration: 1.month.from_now)
   end

   subject { @paste }

   it { should respond_to(:content) }
   it { should respond_to(:title) }
   it { should respond_to(:expiration) }
   it { should respond_to(:language) }
   it { should respond_to(:exposure) }

   it { should be_valid }

   describe "when content is missing" do
       before { @paste.content = "" }
       it { should_not be_valid}
   end

   describe "when title is missing" do
       before { @paste.title = "" }
       it { should be_valid }
   end

   describe "when a language is selected" do
       before { @paste.language = "C++" }
       it { should be_valid }
   end
end
