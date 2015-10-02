# == Define: awstats::vhost
#
# See README.md for more details.
define awstats::vhost (
  $ensure           = 'present',
  $log_file         = undef,
  $site_domain      = undef,
  $host_aliases     = undef,
  $config_overrides = {},
) {

  include awstats
  include awstats::params

  $_log_file = pick($log_file, "/var/log/httpd/${name}.access.log")
  $_site_domain = pick($site_domain, $name)
  $_host_aliases  = pick($host_aliases, "www.${name}")

  $vhost_config = {
    'LogFile' => $_log_file,
    'LogType' => 'W',
    'LogFormat' => '1',
    'LogSeparator' => ' ',
    'DNSLookup' => '2',
    'DirData' => $awstats::data_dir,
    'DirCgi' => '/awstats',
    'DirIcons' => '/awstatsicons',
    'SiteDomain' => $_site_domain,
    'HostAliases' => $_host_aliases,
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
