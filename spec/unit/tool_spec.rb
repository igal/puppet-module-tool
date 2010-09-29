require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Puppet::Module::Tool do
  def reset_http_handle
    ENV['http_proxy'] = nil
    ENV['HTTP_PROXY'] = nil
    Puppet::Module::Tool.instance_variable_set(:@http_handle, nil)
  end

  describe "::http_handle" do
    before(:each) do
      reset_http_handle
    end

    after(:each) do
      reset_http_handle
    end

    describe "with HTTP_PROXY" do
      before(:each) do
        ENV['HTTP_PROXY'] = 'http://user:password@hostname:1234/'
        @handle = Puppet::Module::Tool.http_handle
      end

      specify { @handle.instance_variable_get(:@is_proxy_class).should be_true }
      specify { @handle.proxy_address.should == 'hostname' }
      specify { @handle.proxy_port.should == 1234 }
      specify { @handle.proxy_user.should == 'user' }
      specify { @handle.proxy_pass.should == 'password' }
    end

    describe "without HTTP_PROXY" do
      before(:each) do
        @handle = Puppet::Module::Tool.http_handle
      end

      specify { @handle.instance_variable_get(:@is_proxy_class).should be_false }
      specify { @handle.proxy_address.should be_nil }
      specify { @handle.proxy_port.should be_nil }
      specify { @handle.proxy_user.should be_nil }
      specify { @handle.proxy_pass.should be_nil }
    end
  end
end
