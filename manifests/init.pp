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
}
