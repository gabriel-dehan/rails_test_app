require 'spec_helper'

describe ApplicationHelper do
  describe 'get_title' do
    it 'should include the Application name' do
      app_name_regex   = /App/
      get_title('foo') =~ app_name_regex
      get_title(nil)   =~ app_name_regex
    end

    it 'should at least include the Application name' do
      get_title(nil).should =~ /^App$/
    end

    it 'should include a page title if specified' do
      get_title('foo').should =~ /foo/
    end
  end
end
