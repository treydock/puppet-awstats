require 'spec_helper'

describe 'awstats::vhost' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts.merge({:concat_basedir => '/dne'}) }

      it { should compile.with_all_deps }
    end
  end

  let(:facts) do
    on_supported_os['centos-6-x86_64'].merge({:concat_basedir => '/dne'})
  end

  let(:title) { 'example.com' }
  let(:params) {{  }}

  it { should create_awstats__vhost('example.com') }
  it { should contain_class('awstats') }
  it { should contain_class('awstats::params') }

  it do
    should contain_file('awstats.example.com.conf').with({
      :ensure   => 'file',
      :path     => '/etc/awstats/awstats.example.com.conf',
      :owner    => 'root',
      :group    => 'root',
      :mode     => '0644',
      :require  => 'File[/etc/awstats]',
    })
  end

  it do
    file_content = catalogue.resource('file', "awstats.example.com.conf").send(:parameters)[:content]
    content = file_content.split("\n").reject { |c| c =~ /(^#|^$)/ }
    expected = [
      'AllowFullYearView=2',
      'AllowToUpdateStatsFromBrowser=0',
      'DNSLookup=2',
      'DirCgi="/awstats"',
      'DirData="/var/lib/awstats"',
      'DirIcons="/awstatsicons"',
      'HostAliases="www.example.com"',
      'LogFile="/var/log/httpd/example.com.access.log"',
      'LogFormat=1',
      'LogSeparator=" "',
      'LogType="W"',
      'SiteDomain="example.com"',
    ]
    content.should == expected
  end

end
