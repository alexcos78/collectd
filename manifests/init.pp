# @License
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
# Author: Alessandro Costatnini <acostantini@infn.it>
# 
# == Class: collectd
#
# init takes care of installing/configuring collectd and the common dependencies 
# for accounting puroposes of INFN-CLOUD and Federated sites
# === Parameters:
#
# [*influxdb_collectd_host*] Host for influxdb, usually local accounting server.
#   Mandatory.
# [*influxdb_collectd_port*] Port related to the influxdb host, usually 25826.
#   Mandatory.
# 
#   include collectd
class collectd (
  $influxdb_collectd_host        = undef,
  $influxdb_collectd_port        = "25826",
 ) inherits collectd::params {

if defined('$influxdb_collectd_host') {
   notify {"Variable influxdb_collectd_host is: $influxdb_collectd_host":}
} else {
   fail("Variable influxdb_collectd_host is unset.")
}

case $::osfamily {
    'RedHat', 'CentOS':  {
         notify {'You are using CentOS': }
         class { 'setup::redhat' :
           influxdb_collectd_host => $influxdb_collectd_host,
           influxdb_collectd_port => $influxdb_collectd_port
         }

    }
    'Debian', 'Ubuntu':  {
         notify {'You are using Ubuntu': }
         class { 'setup::debian' :
           influxdb_collectd_host => $influxdb_collectd_host,
           influxdb_collectd_port => $influxdb_collectd_port
         }
    }
    default:  {
         fail("No suitable OS found for this Class:  ${::osfamily}/${::operatingsystem}")
    }
}

}
