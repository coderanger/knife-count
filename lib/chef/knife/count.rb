#
# Copyright 2016, Noah Kantrowitz
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

require 'chef/knife'


module KnifeCount
  # This has to be a sub-module because the name is used by knife to compute the
  # command name.
  class Count < Chef::Knife

    banner 'knife count [TYPE] QUERY'

    deps do
      require 'addressable/uri'
    end

    def run
      parse_cli_args
      fuzzify_query
      run_search
    end

    private

    def parse_cli_args
      case name_args.length
      when 0
        @type = 'node'
        @query = '*:*'
      when 1
        @type = 'node'
        @query = name_args.first
      else
        @type = name_args[0]
        @query = name_args[1..-1].join(' ')
      end
    end

    # From chef/knife/search.rb.
    # Copyright 2009-2016, Chef Software Inc.
    # Used under the terms of the Apache 2.0 License.
    def fuzzify_query
      if @query !~ /:/
        @query = "tags:*#{@query}* OR roles:*#{@query}* OR fqdn:*#{@query}* OR addresses:*#{@query}* OR policy_name:*#{@query}* OR policy_group:*#{@query}*"
      end
    end

    def run_search
      escaped_query = Addressable::URI.encode_component(@query, Addressable::URI::CharacterClasses::QUERY)
      response = rest.post("/search/#{@type}?q=#{escaped_query}&rows=1", {})
      ui.msg(response['total'])
    end

  end
end
