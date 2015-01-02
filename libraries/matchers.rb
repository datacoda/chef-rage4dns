if defined?(ChefSpec)
  ChefSpec.define_matcher :rage4dns_record

  def create_rage4dns_record(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:rage4dns_record, :create, resource_name)
  end

  def delete_rage4dns_record(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:rage4dns_record, :delete, resource_name)
  end
end
