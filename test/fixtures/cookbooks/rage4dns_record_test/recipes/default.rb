# Unit Test

# We want to have follow-through for the resource name

rage4dns_record 'test' do
  domain node['unit_testing']['domain']

  type 'A'
  value '16.8.4.2'

  rage_access_key_id node['rage4dns']['rage_access_key_id']
  rage_secret_access_key node['rage4dns']['rage_secret_access_key']

  ttl 350
  geozone 'Africa'

  action :create
end

# This record appends to the former, but through a different geozone
# It also tests the failover settings.

rage4dns_record 'test-europe' do
  record_name 'test'
  domain node['unit_testing']['domain']

  type 'A'
  value '16.8.4.3'

  rage_access_key_id node['rage4dns']['rage_access_key_id']
  rage_secret_access_key node['rage4dns']['rage_secret_access_key']

  geozone 'Europe'

  failover true
  failover_content '127.0.0.11'

  action :create
end

# Let's create a temporary record

rage4dns_record 'create-temp-test' do
  record_name 'test'
  domain node['unit_testing']['domain']

  type 'A'
  value '16.8.4.2'

  rage_access_key_id node['rage4dns']['rage_access_key_id']
  rage_secret_access_key node['rage4dns']['rage_secret_access_key']

  ttl 330
  geozone 'CanadaWest'

  action :create
end

# Update the TTL and failover on that temp record

rage4dns_record 'update-temp-test' do
  record_name 'test'
  domain node['unit_testing']['domain']

  type 'A'
  value '16.8.4.2'

  rage_access_key_id node['rage4dns']['rage_access_key_id']
  rage_secret_access_key node['rage4dns']['rage_secret_access_key']

  ttl 10
  geozone 'CanadaWest'

  failover true
  failover_content '127.0.0.11'

  action :create
end

# Let's delete that temporary record.  It should match by strict name, type, value, zone.

rage4dns_record 'delete-temp-test' do
  record_name 'test'
  domain node['unit_testing']['domain']

  type 'A'
  value '16.8.4.2'

  rage_access_key_id node['rage4dns']['rage_access_key_id']
  rage_secret_access_key node['rage4dns']['rage_secret_access_key']

  ttl 360 # will be ignored by matcher
  geozone 'CanadaWest'

  action :delete
end
