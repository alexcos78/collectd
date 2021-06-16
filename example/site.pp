node default {
 class { 'collectd' :
   influxdb_collectd_host => 'accounting.novalocal'
 }
}
