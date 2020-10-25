#
#
#
class profile_bind (
  Array[String]      $forwarders      = ['8.8.8.8', '8.8.4.4'],
  Enum['yes', 'no']  $dnssec          = 'yes',
  Boolean            $manage_firewall = true,
  Hash[String, Hash] $zones           = {},
  Hash[String, Hash] $zones_defaults  = {},
  Hash[String, Hash] $keys            = {},
) {
  class { 'dns':
    forwarders    => $forwarders,
    dnssec_enable => $dnssec,
  }
  create_resources(dns::zones, $zones, $zones_defaults)
  if $manage_firewall {
    firewall { '00053 allow bind':
      dport  => 53,
      action => 'accept',
    }
  }
}
