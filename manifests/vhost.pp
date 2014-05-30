# == Define: awstats::vhost
#
# See README.md for more details.
define awstats::vhost (
  $log_file         = 'UNSET',
  $site_domain      = 'UNSET',
  $host_aliases     = 'UNSET',
  $config_overrides = {},
  $ensure           = 'present',
) {

  include awstats
  include awstats::params

  $log_file_real = $log_file ? {
    'UNSET' => "/var/log/httpd/${name}.access.log",
    default => $log_file,
  }

  $site_domain_real = $site_domain ? {
    'UNSET' => $name,
    default => $site_domain,
  }

  $host_aliases_real = $host_aliases ? {
    'UNSET' => "www.${name}",
    default => $host_aliases,
  }

  $vhost_config = {
    'LogFile' => $log_file_real,
    'LogType' => 'W',
    'LogFormat' => '1',
    'LogSeparator' => ' ',
    'DNSLookup' => '2',
    'DirData' => '/var/lib/awstats',
    'DirCgi' => '/awstats',
    'DirIcons' => '/awstatsicons',
    'SiteDomain' => $site_domain_real,
    'HostAliases' => $host_aliases_real,
    'AllowToUpdateStatsFromBrowser' => '0',
    'AllowFullYearView' => '2',
  }

  #$vhost_config_real  = merge($awstats::params::vhost_config_defaults, $vhost_config)
  #$config             = merge($vhost_config_real, $config_overrides)
  $config             = merge($vhost_config, $config_overrides)

  file { "awstats.${name}.conf":
    ensure  => 'file',
    path    => "${awstats::config_dir}/awstats.${name}.conf",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('awstats/awstats.vhost.conf.erb'),
    require => File['/etc/awstats'],
  }

}
