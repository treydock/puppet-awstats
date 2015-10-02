# puppet-awstats

[![Build Status](https://travis-ci.org/treydock/puppet-awstats.png)](https://travis-ci.org/treydock/puppet-awstats)

#### Table of Contents

1. [Overview](#overview)
2. [Usage - Configuration options](#usage)
3. [Reference - Parameter and detailed reference to all options](#reference)
    * [Public Classes](#public-classes)
    * [Public Defines](#public-defines)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)
6. [TODO](#todo)
7. [Additional Information](#additional-information)

## Overview

This module will manage AWStats.  Once installed awstats can be accessed by going to http://URL/awstats.  This setup is intended to allow a VirtualHost's awstats to be accessed by going to http://VirtualHost-URL/awstats.

## Usage

### Class: awstats

The default behavior will install awstats and setup the Apache configuration to only allow access to 127.0.0.1.

Allowing additional addresses:

    class { 'awstats':
      allow_from => ['127.0.0.1', '10.0.0.0/8'],
    }

A hash of key/value pairs can be used to configure the <Location> directive for /awstats.  For example, setting up authentication for awstats and allow all IP addresses:
  
    class { 'awstats':
      allow_from        => ['all'],
      location_configs  => {
        'SSLRequireSSL'               => true,
        'AuthType'                    => 'basic',
        'AuthName'                    => '"Secure Area"',
        'AuthBasicProvider'           => 'ldap',
        'AuthLDAPUrl'                 => '"ldap://ldap.example.com/ou=People,dc=example,dc=com?uid?sub" TLS',
        'AuthLDAPBindDN'              => '"uid=app_bind,ou=Service Accounts,dc=example,dc=com"',
        'AuthLDAPBindPassword'        => '"password"',
        'AuthLDAPGroupAttribute'      => 'uniquemember',
        'AuthLDAPGroupAttributeIsDN'  => 'On',
        'Require'                     => 'ldap-group cn=admins,ou=Groups,dc=example,dc=com',
      }
    }

### Define: awstats::vhost

The awstats::vhost define is used to configure additional websites in awstats.

If your logs are at /var/www/httpd/${URL}.access.log, then this should be enough to get a site configured.

    awstats::vhost { 'foo.example.com': }

The above example will produce the following configuration file:

    AllowFullYearView=2
    AllowToUpdateStatsFromBrowser=0
    DNSLookup=2
    DirCgi="/awstats"
    DirData="/var/lib/awstats"
    DirIcons="/awstatsicons"
    HostAliases="www.foo.example.com"
    LogFile="/var/log/httpd/foo.example.com.access.log"
    LogFormat=1
    LogSeparator=" "
    LogType="W"
    SiteDomain="foo.example.com"

## Reference

* [Public Classes](#public-classes)
  * [Class: awstats](#class-awstats)
* [Private Classes](#private-classes)
  * [Class: awstats::params](#class-awstatsparams)
* [Public Defines](#public-defines)
  * [Define: awstats::vhost](#define-awstatsvhost)

### Public Classes

#### Class: `awstats`:

Installs and configures awstats

##### `package_name`

Name of awstats package.  Default: `awstats`

##### `package_require`

Resources required to install awstats package.  Default: `Yumrepo[epel]`

##### `config_dir`

Directory containing awstat configurations.  Default: `/etc/awstats`

##### `data_dir`

The `DataDir` value used when configuring awstats.  Default: `/var/lib/awstats`

##### `data_dir_owner`

The owner of `DataDir`.  Default: `apache`

##### `data_dir_group`

The group set for `DataDir`.  Default: `apache`

##### `manage_apache`

Boolean that determines if the `apache` class should be included.  Default: `true`

##### `allow_from`

Array used to define the `Allow from` in Apache. Default: `['127.0.0.1']`

##### `apache_confd_dir`

The directory containing Apache configurations.  Default: `/etc/httpd/conf.d`

##### `location_configs`

A Hash that can be used to used to configure the Apache directive for `<Location /awstats>`.  Default: `{}`

##### `vhosts`

A Hash that can be used to define `awstats::vhost` resources.  Default: `{}`

### Private Classes

#### Class: `awstats::params`:

Sets parameter defaults

### Public Defines

#### Define: `awstats::vhost`

Configures individual websites in awstats.

##### `ensure`

Ensure value passed to the file resource that configures the defined awstats::vhost.  Default: `present`

##### `log_file`

The path to the defined website's Apache access log. Default: `/var/log/httpd/${name}.access.log`

##### `site_domain`

The `SiteDomain` value configured in awstats.  Default: `$name`

##### `host_aliases`

An string of space separated aliases for this website, passed to `HostAliases`.  Default: `www.${name}`

##### `config_overrides`

A Hash of key/value pair configurations to pass to the configuration of this vhost in awstats.  Default: `{}`

## Limitations

Tested using

* CentOS 6

## Development

### Testing

Testing requires the following dependencies:

* rake
* bundler

Install gem dependencies

    bundle install

Run unit tests

    bundle exec rake test

If you have Vagrant >= 1.2.0 installed you can run system tests

    bundle exec rake beaker

## TODO

## Further Information

* 
