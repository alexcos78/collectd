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
# == Class: accounting::role::debian
#
# init takes care of installing/configuring collectd and the common dependencies
# for accounting puroposes for Debian OS
# === Parameters:
#
# [*influxdb_collectd_host*] Host for influxdb, usually local accounting server.
#   Mandatory.
# [*influxdb_collectd_port*] Port related to the influxdb host, usually 25826.
#   Mandatory.
#
#   include collectd

class accounting::role::redhat (
  $influxdb_collectd_host        = undef,
  $influxdb_collectd_port        = "25826",
) {

    $collectdpackages= [ 'collectd', 'collectd-virt']
  
    package { $collectdpackages :
              ensure => 'installed',
                   }
                   

   file { "/etc/collectd.conf":
         ensure   => file,
         owner    => "root",
         group    => "root",
         mode     => '0644',
         content  => template("templates/collectd.conf-deb.erb"),
         require => Package[$collectdpackages],
       }


    cron {'collectd_flush_cache':
             ensure      => present,
             command     => "/usr/bin/killall -SIGUSR1 collectd",
             user        => root,
             minute      => '0',
             hour        => '*/2'
          }


   service { "collectd":
                             ensure      => running,
                             enable      => true,
                             hasstatus   => true,
                             hasrestart  => true,
                             require     => Package[$collectdpackages],
                             subscribe   => File['/etc/collectd.conf'],
                    }
                    
       
  }
