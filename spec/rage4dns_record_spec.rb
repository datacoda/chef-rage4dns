require 'spec_helper'

describe 'rage4dns_record_test::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      platform: 'ubuntu',
      version: '12.04'
      ) do |node|
        node.set['rage4dns'] = {
          rage_access_key_id: 'something@foo.bar',
          rage_secret_access_key: 'abcd1234'
        }
        node.set['unit_testing'] = {
          domain: 'example.com',
          record_action: 'create'
        }
      end.converge(described_recipe)
  end

  it 'creates a test record' do
    expect(chef_run).to create_rage4dns_record('test')
    expect(chef_run).to create_rage4dns_record('test-europe')
    expect(chef_run).to create_rage4dns_record('create-temp-test')
    expect(chef_run).to create_rage4dns_record('update-temp-test')
    expect(chef_run).to delete_rage4dns_record('delete-temp-test')
  end
end
