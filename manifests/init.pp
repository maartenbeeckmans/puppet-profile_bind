#
#
#
class profile_bind (
  Array[String]      $forwarders      = ['8.8.8.8', '8.8.4.4'],
  Enum['yes', 'no']  $dnssec          = true,
  Boolean            $manage_firewall = true,
  Hash[String, Hash] $zones           = {},
  Hash[String, Hash] $keys            = {},
) {
  class { 'dns':
    forwarders    => $forwarders,
    dnssec_enable => $dnssec,
  }
  if $manage_firewall {
    firewall { '00053 allow bind':
      dport  => 53,
      action => 'accept',
    }
  }
}
