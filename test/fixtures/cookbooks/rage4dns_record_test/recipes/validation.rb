# Validation test

rage4dns_record 'validation-test' do
  domain 'example.com'

  type 'A'

  # commented line should throw validation exception
  # rage_access_key_id node['rage4dns']['rage_access_key_id']
  # value '16.8.4.2'

  rage_secret_access_key 'abcd1234'

  ttl 350
  geozone 'Africa'

  action :create
end
