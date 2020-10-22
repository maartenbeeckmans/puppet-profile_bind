#
#
#
class profile_bind (
  Array[Stdlib::IP::Address] $forwarders      = ['8.8.8.8', '8.8.4.4'],
  Boolean                    $dnssec          = true,
  Hash                       $bind_keys       = {},
  Hash                       $bind_acls       = {},
  Hash                       $bind_zones      = {},
  Hash                       $bind_views      = {},
  Hash                       $bind_records    = {},
  Boolean                    $manage_firewall = true,
) {
  class { 'bind':
    forwarders => $forwarders,
    dnssec     => $dnssec,
    version    => 'Controlled by Puppet',
  }
  create_resources(bind::key, $bind_keys)
  create_resources(bind::acl, $bind_acls)
  create_resources(bind::zone, $bind_zones)
  create_resources(bind::view, $bind_views)
  create_resources(recource_record, $bind_records)

  if $manage_firewall {
    firewall { '00053 allow bind':
      dport  => 53,
      action => 'accept',
    }
  }
}
