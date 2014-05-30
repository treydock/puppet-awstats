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
      'ScriptAlias /awstats/ "/usr/share/awstats/wwwroot/cgi-bin/"',
      '<Directory "/usr/share/awstats/wwwroot">',
      '    Options None',
      '    AllowOverride None',
      '    Order Allow,Deny',
      '    Allow from 127.0.0.1',
      '</Directory>',
      '<IfModule mod_env.c>',
      '    SetEnv PERL5LIB /usr/share/awstats/lib:/usr/share/awstats/plugins',
      '</IfModule>',
    ])
  end
end
