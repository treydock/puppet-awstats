# == Class: awstats
#
class awstats (
  $package_name         = $awstats::params::package_name,
  $package_require      = $awstats::params::package_require,
  $config_dir           = $awstats::params::config_dir,
  $data_dir             = $awstats::params::data_dir,
  $data_dir_owner       = $awstats::params::apache_user,
  $data_dir_group       = $awstats::params::apache_group,
  $manage_apache        = true,
  $allow_from           = ['127.0.0.1'],
  $apache_confd_dir     = $awstats::params::apache_confd_dir,
  $location_configs     = {},
  $vhosts               = {},
) inherits awstats::params {

  validate_array($allow_from)
  validate_hash($location_configs, $vhosts)

  case $::osfamily {
    'RedHat': {
      include epel
    }
    default: {
      # do nothing
    }
  }

  if $manage_apache {
    include apache
  }

  package { 'awstats':
    ensure  => present,
    name    => $package_name,
    before  => [ File['/etc/awstats'], File['/var/lib/awstats'] ],
    require => $package_require,
  }

  file { '/etc/awstats':
    ensure => 'directory',
    path   => $config_dir,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { '/var/lib/awstats':
    ensure => 'directory',
    path   => $data_dir,
    owner  => $data_dir_owner,
    group  => $data_dir_group,
    mode   => '0755',
  }

  file { 'awstats.conf':
    ensure  => 'file',
    path    => "${apache_confd_dir}/awstats.conf",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('awstats/awstats.apache.conf.erb'),
    require => [ Package['httpd'], Package['awstats'] ],
    notify  => Service['httpd'],
  }

  create_resources('awstats::vhost', $vhosts)
}
