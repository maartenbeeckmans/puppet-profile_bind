#
#
#
class profile_bind (
  Array[String]      $forwarders,
  Boolean            $manage_firewall_entry,
  Hash[String, Hash] $zones,
  Hash               $zones_defaults,
  Hash[String, Hash] $keys,
  Boolean            $forward_consul,
  String             $consul_domain,
  String             $consul_server,
  Integer            $consul_port,
  String             $sd_service_name,
  Array[String]      $sd_service_tags,
  Boolean            $manage_sd_service            = lookup('manage_sd_service', Boolean, first, true),
) {
  class { 'dns':
    forwarders    => $forwarders,
  }
  create_resources(dns::zone, $zones, $zones_defaults)
  create_resources(dns::key, $keys)
  if $manage_firewall_entry {
    firewall { '00053 allow bind TCP':
      dport  => 53,
      action => 'accept',
      proto  => 'tcp',
    }
    firewall { '00053 allow bind UDP':
      dport  => 53,
      action => 'accept',
      proto  => 'udp',
    }
  }
  if $forward_consul {
    dns::zone { $consul_domain:
      zonetype    => 'forward',
      forward     => 'only',
      forwarders  => ["${consul_server} port ${consul_port}"],
      manage_file => false,
    }
  }
  if $manage_sd_service {
    consul::service { $sd_service_name:
      checks => [
        {
          tcp      => "${facts[networking][ip]}:53",
          interval => '10s',
        }
      ],
      port   => 53,
      tags   => $sd_service_tags,
    }
  }
}
