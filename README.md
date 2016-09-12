# knife-count

[![Build Status](https://img.shields.io/travis/coderanger/knife-count.svg)](https://travis-ci.org/coderanger/knife-count)
[![Gem Version](https://img.shields.io/gem/v/knife-count.svg)](https://rubygems.org/gems/knife-count)
[![Gemnasium](https://img.shields.io/gemnasium/coderanger/knife-count.svg)](https://gemnasium.com/coderanger/knife-count)
[![License](https://img.shields.io/badge/license-Apache_2-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0)


knife-count is a little knife plugin to get the number of nodes (or other items)
in a Chef search query more quickly than with `knife search`.

```bash
$ knife count chef_environment:prod
1632
```

## Installation

Install the plugin as a gem:

```bash
chef gem install knife-count
```

## Usage

To get the total number of results from a node query:

```bash
knife count "QUERY"
```

To search other object types:

```bash
knife count TYPE "QUERY"
```

To get the count of all nodes (search `*:*`):

```bash
knife count
```

## Sponsors

Development sponsored by [Bloomberg](http://www.bloomberg.com/company/technology/).

## License

Copyright 2016, Noah Kantrowitz

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
