require 'spec_helper'

# Ensure binary is not writable
describe file('/opt/rage4dns/bin/ddrage4client') do
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should_not be_writable.by('others') }
  it { should_not be_executable.by('others') }
end

# Ensure configuration isn't readable
describe file('/etc/rage4dns/ddrage4client.conf') do
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should_not be_readable.by('others') }
  it { should_not be_writable.by('others') }
  it { should_not be_executable.by('others') }

  it { should contain 'http://test_resolver.me/' }

  it { should contain 'foo.example.com=5555beef' }
  it { should contain 'dyn.example.com=5555dead' }
end

describe file('/etc/cron.d/ddrage4client') do
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should_not be_writable.by('others') }

  it { should contain '*/5' }
  it { should contain '/opt/rage4dns/bin/ddrage4client' }
end
