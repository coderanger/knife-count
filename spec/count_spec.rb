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

require 'spec_helper'
require 'chef_zero/data_store/raw_file_store'
require 'chef_zero/server'
require 'chef/knife/count'

describe KnifeCount::Count do
  before(:all) do
    @server = ChefZero::Server.new(port: 4000)
    # Load some fixture data in.
    @server.load_data(
      'nodes' => {
        'node1' => {'chef_environment' => 'prod', 'automatic' => {'roles' => 'web'}},
        'node2' => {'chef_environment' => 'prod', 'automatic' => {'roles' => 'db'}},
        'node3' => {'chef_environment' => 'staging', 'automatic' => {'roles' => 'web'}},
        'node4' => {'chef_environment' => 'staging', 'automatic' => {'roles' => 'db'}},
      },
      'roles' => {
        'web' => {'description' => 'web servers'},
        'db' => {'description' => 'db servers'},
      }
    )
    # Start in a background thread.
    @server.start_background
  end

  after(:all) do
    @server.stop if @server
  end

  context 'test harness baseline' do
    # Test using `knife search` to make sure we know the test harness works.
    command 'knife search -s http://localhost:4000/ "chef_environment:prod"'
    its(:stdout) do
      is_expected.to match(/^Node Name:\s+node1$/)
      is_expected.to match(/^Node Name:\s+node2$/)
      is_expected.to_not match(/^Node Name:\s+node3$/)
      is_expected.to_not match(/^Node Name:\s+node4$/)
    end
  end # /context test harness baseline

  context 'default search' do
    command 'knife count -s http://localhost:4000/'
    its(:stdout) { is_expected.to eq "4\n" }
  end # /context default search

  context 'simple node search' do
    command 'knife count -s http://localhost:4000/ "chef_environment:prod"'
    its(:stdout) { is_expected.to eq "2\n" }
  end # /context simple node search

  context 'explicit node search' do
    command 'knife count -s http://localhost:4000/ node "chef_environment:prod"'
    its(:stdout) { is_expected.to eq "2\n" }
  end # /context explicit node search

  context 'complex node search' do
    command 'knife count -s http://localhost:4000/ "chef_environment:prod AND roles:web"'
    its(:stdout) { is_expected.to eq "1\n" }
  end # /context complex node search

  context 'role search' do
    command 'knife count -s http://localhost:4000/ role "*:*"'
    its(:stdout) { is_expected.to eq "2\n" }
  end # /context role search

end
