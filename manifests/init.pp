#
#
#
class profile_bind (
  Array[Stdlib::IP::Address] $forwarders = ['8.8.8.8', '8.8.4.4'],
  Boolean                    $dnssec     = true,
) {
  class { 'bind':
    forwarders => $forwarders,
    dnssec     => $dnssec,
    version    => 'Controlled by Puppet',
  }
}
