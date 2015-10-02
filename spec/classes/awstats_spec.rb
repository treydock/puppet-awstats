require 'spec_helper'

describe 'awstats' do
  let :facts do
    {
      :osfamily               => 'RedHat',
      :operatingsystemrelease => '6.5',
      :concat_basedir         => '/dne',
    }
  end

  let(:params) {{  }}

  it { should create_class('awstats') }
  it { should contain_class('awstats::params') }
  it { should contain_class('epel') }
  it { should contain_class('apache') }

  it do
    should contain_package('awstats').with({
      'ensure'    => 'present',
      'name'      => 'awstats',
      'before'    => ['File[/etc/awstats]','File[/var/lib/awstats]'],
      'require'   => 'Yumrepo[epel]',
    })
  end

  it do
    should contain_file('/etc/awstats').with({
      'ensure'  => 'directory',
      'path'    => '/etc/awstats',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0755',
    })
  end

  it do
    should contain_file('/var/lib/awstats').with({
      'ensure'  => 'directory',
      'path'    => '/var/lib/awstats',
      'owner'   => 'apache',
      'group'   => 'apache',
      'mode'    => '0755',
    })
  end

  it do
    should contain_file('awstats.conf').with({
      'ensure'  => 'file',
      'path'    => '/etc/httpd/conf.d/awstats.conf',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0644',
      'require' => ['Package[httpd]', 'Package[awstats]'],
    })
  end

  it 'should create valid awstats.conf' do
    verify_contents(catalogue, 'awstats.conf', [
      'Alias /awstatsclasses "/usr/share/awstats/wwwroot/classes/"',
      'Alias /awstatscss "/usr/share/awstats/wwwroot/css/"',
      'Alias /awstatsicons "/usr/share/awstats/wwwroot/icon/"',
      'Alias /awstats "/usr/share/awstats/wwwroot/cgi-bin"',
      '<Directory "/usr/share/awstats/wwwroot">',
      '  Options None',
      '  AllowOverride None',
      '  Order Allow,Deny',
      '  Allow from 127.0.0.1',
      '</Directory>',
      '<Directory "/usr/share/awstats/wwwroot/cgi-bin">',
      '  DirectoryIndex awstats.pl',
      '  Options ExecCGI',
      '  AddHandler cgi-script .pl',
      #'</Directory>', #Duplicate lines upset verify_contents
      '<IfModule mod_env.c>',
      '  SetEnv PERL5LIB /usr/share/awstats/lib:/usr/share/awstats/plugins',
      '</IfModule>',
    ])
  end

  context 'when location_configs are defined' do
    let(:params) do
      {
        :location_configs => {
          'SSLRequireSSL' => true,
          'AuthType' => 'basic',
          'AuthName' => '"Secure Area"',
          'AuthBasicProvider' => 'ldap',
          'AuthLDAPUrl' => '"ldap://ldap.example.com/ou=People,dc=example,dc=com?uid?sub" TLS',
          'AuthLDAPBindDN' => '"uid=app_bind,ou=Service Accounts,dc=example,dc=com"',
          'AuthLDAPBindPassword' => '"password"',
          'AuthLDAPGroupAttribute' => 'uniquemember',
          'AuthLDAPGroupAttributeIsDN' => 'On',
          'Require' => 'ldap-group cn=admins,ou=Groups,dc=example,dc=com',
        }
      }
    end

    it 'should create valid awstats.conf' do
      #content = catalogue.resource('file', 'awstats.conf').send(:parameters)[:content]
      #pp content.split(/\n/)
      verify_contents(catalogue, 'awstats.conf', [
        'Alias /awstatsclasses "/usr/share/awstats/wwwroot/classes/"',
        'Alias /awstatscss "/usr/share/awstats/wwwroot/css/"',
        'Alias /awstatsicons "/usr/share/awstats/wwwroot/icon/"',
        'Alias /awstats "/usr/share/awstats/wwwroot/cgi-bin"',
        '<Directory "/usr/share/awstats/wwwroot">',
        '  Options None',
        '  AllowOverride None',
        '  Order Allow,Deny',
        '  Allow from 127.0.0.1',
        '</Directory>',
        '<Directory "/usr/share/awstats/wwwroot/cgi-bin">',
        '  DirectoryIndex awstats.pl',
        '  Options ExecCGI',
        '  AddHandler cgi-script .pl',
        #'</Directory>', #Duplicate lines upset verify_contents
        '<IfModule mod_env.c>',
        '  SetEnv PERL5LIB /usr/share/awstats/lib:/usr/share/awstats/plugins',
        '</IfModule>',
        '<Location /awstats>',
        '  AuthBasicProvider ldap',
        '  AuthLDAPBindDN "uid=app_bind,ou=Service Accounts,dc=example,dc=com"',
        '  AuthLDAPBindPassword "password"',
        '  AuthLDAPGroupAttribute uniquemember',
        '  AuthLDAPGroupAttributeIsDN On',
        '  AuthLDAPUrl "ldap://ldap.example.com/ou=People,dc=example,dc=com?uid?sub" TLS',
        '  AuthName "Secure Area"',
        '  AuthType basic',
        '  Require ldap-group cn=admins,ou=Groups,dc=example,dc=com',
        '  SSLRequireSSL',
        '</Location>',
      ])
    end
  end
end
