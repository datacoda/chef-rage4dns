#
# Cookbook Name:: rage4dns
# Library:: rageapi
#
# Copyright (C) 2014 Nephila Graphic
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'open-uri'
require 'json'

class Rage4
  class API
    def initialize(auth_id, auth_key)
      @auth_id = auth_id
      @auth_key = auth_key
      @cache_domain = {}
      @cache_geozone = {}
    end

    # Attempts to create a record as specified.
    # It performs a match check on existing records to make sure we don't duplicate. If it exists, changes are applied.
    # Returns true if created or changed.
    #
    def create(domain_name, type:nil, name:nil, content:nil, ttl:nil, failover:false, failover_content:nil, geozone:'World')
      state_changed = false

      domain_id = get_domain_by_name(domain_name)
      geo_region_id = get_geozone_by_name(geozone)

      # pull down the list to make sure we're not already matching
      result = match_records(domain_id,
        'type' => type,
        'name' => name,
        'content' => content,
        'geo_region_id' => geo_region_id
      )

      if result.empty?
        url_cmd = "https://secure.rage4.com/rapi/createrecord/#{domain_id}?name=#{name}&content=#{content}&type=#{type}&geozone=#{geo_region_id}"

        # optional parameters (sent only if specified)
        url_cmd += "&ttl=#{ttl}" unless ttl.nil?
        url_cmd += "&failover=#{failover}" unless failover.nil?
        url_cmd += "&failovercontent=#{failover_content}" unless failover_content.nil?

        buffer = open(url_cmd, http_basic_authentication: [@auth_id, @auth_key]).read
        result = JSON.parse(buffer)
        if result['status']
          state_changed = true
          Chef::Log.info "Created record #{result['id']} #{type} #{name} #{content} #{ttl} #{geozone}"
        else
          Chef::Log.error("Rage4 API error: #{result['error']}")
        end
      else
        # There's a possibility that there is an existing, at least in terms of region and basic info.
        # optional parameters such as TTL and failover will need to be updated in that case.

        result.each do |record|
          # Note that the record result structure has slightly different fields than the api fields.
          options_update = {}
          options_update['ttl'] = { oldvalue: record['ttl'], newvalue: ttl } unless ttl.nil?
          options_update['failover_enabled'] = { oldvalue: record['failover_enabled'], newvalue: failover } unless failover.nil?
          options_update['failover_content'] = { oldvalue: record['failover_content'], newvalue: failover_content } unless failover_content.nil?

          rejected_fields = options_update.select { |_criteria, value| value[:oldvalue] != value[:newvalue] }
          unless rejected_fields.empty?
            Chef::Log.info("Updating fields #{rejected_fields}")

            url_cmd = "https://secure.rage4.com/rapi/updaterecord/#{record['id']}?name=#{name}&content=#{content}&geozone=#{geo_region_id}"

            # optional parameters (sent only if specified)
            url_cmd += "&ttl=#{ttl}" unless ttl.nil?
            url_cmd += "&failover=#{failover}" unless failover.nil?
            url_cmd += "&failovercontent=#{failover_content}" unless failover_content.nil?

            buffer = open(url_cmd, http_basic_authentication: [@auth_id, @auth_key]).read
            result = JSON.parse(buffer)

            if result['status']
              state_changed = true
              Chef::Log.info("Overwrite record #{record['id']} #{record['type']} #{record['content']} #{record['name']} #{geozone}")
            else
              Chef::Log.error("Rage4 API error: #{result['error']}")
            end
          end
        end
      end

      state_changed
    end

    # Deletes a record from the domain
    # It performs a match check against all existing records of that type and name.
    # matcher is a hash.
    # Returns true if a record was deleted.
    #
    def delete(domain_name, type:nil, name:nil, content:nil, geozone:nil)
      state_changed = false

      domain_id = get_domain_by_name(domain_name)

      matcher = {
        'type' => type,
        'name' => name
      }

      matcher['geo_region_id'] = get_geozone_by_name(geozone) unless geozone.nil?
      matcher['content'] = content unless content.nil?

      match_records(domain_id, matcher).each do |record|
        url_cmd = "https://secure.rage4.com/rapi/deleterecord/#{record['id']}"
        buffer = open(url_cmd, http_basic_authentication: [@auth_id, @auth_key]).read
        result = JSON.parse(buffer)

        if result['status']
          state_changed = true
          Chef::Log.info "Deleted record #{record['id']} #{record['type']} #{record['name']} #{content} #{geozone}" if result['status']
        else
          Chef::Log.error("Rage4 API error: #{result['error']}")
        end
      end

      state_changed
    end

    # PRIVATE CLASS MEMBERS
    # ---------------------

    private

    def get_domain_by_name(domain_name)
      return @cache_domain[domain_name] if @cache_domain.key? domain_name

      url_cmd = "https://secure.rage4.com/rapi/getdomainbyname/?name=#{domain_name}"
      buffer = open(url_cmd, http_basic_authentication: [@auth_id, @auth_key]).read
      result = JSON.parse(buffer)
      @cache_domain[domain_name] = result['id']
    end

    def get_geozone_by_name(geozone_name)
      return @cache_geozone[geozone_name] if @cache_geozone.key? geozone_name

      url_cmd = 'https://secure.rage4.com/rapi/listgeoregions/'
      buffer = open(url_cmd, http_basic_authentication: [@auth_id, @auth_key]).read
      result = JSON.parse(buffer)
      result.each do |geozone|
        @cache_geozone[geozone['name']] = geozone['value']
      end

      @cache_geozone[geozone_name]
    end

    def get_records(domain_id)
      url_cmd = "https://secure.rage4.com/rapi/getrecords/#{domain_id}"
      buffer = open(url_cmd, http_basic_authentication: [@auth_id, @auth_key]).read
      JSON.parse(buffer)
    end

    def match_records(domain_id, matcher)
      get_records(domain_id).select do |record|
        rejected_fields = matcher.select { |criteria, value| record[criteria] != value }
        rejected_fields.empty?
      end
    end
  end
end
