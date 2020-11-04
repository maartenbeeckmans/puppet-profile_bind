#
#
#
class profile_bind (
  Array[String]      $forwarders            = ['8.8.8.8', '8.8.4.4'],
  Boolean            $manage_firewall_entry = true,
  Hash[String, Hash] $zones                 = {},
  Hash               $zones_defaults        = {},
  Hash[String, Hash] $keys                  = {},
  Boolean            $forward_consul        = false,
  Array[String]      $consul_forwarders     = [],
) {
  class { 'dns':
    forwarders    => $forwarders,
  }
  create_resources(dns::zone, $zones, $zones_defaults)
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
    dns::zone { 'consul':
      zonetype    => 'forward',
      forward     => 'only',
      forearders  => $consul_forwarders,
      manage_file => false,
    }
  }
}
