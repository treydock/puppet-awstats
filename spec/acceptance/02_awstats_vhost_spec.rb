require 'spec_helper_acceptance'

describe 'awstats::vhost define:' do
  context 'default parameters' do
    it 'should run successfully' do
      pp =<<-EOS
        class { 'awstats': }
        host { 'test.localdomain': ip => '127.0.0.1' }
        apache::vhost { 'test.localdomain':
          docroot         => '/var/www/test.localdomain',
          port            => '80',
          access_log_file => '/var/log/httpd/test.localdomain.access.log',
        }
        awstats::vhost { 'test.localdomain':
          log_file => '/var/log/httpd/test.localdomain.access.log',
        }
      EOS
  
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe package('awstats') do
      it { should be_installed }
    end

    describe file('/etc/awstats') do
      it { should be_directory }
      it { should be_mode 755 }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
    end

    describe file('/var/lib/awstats') do
      it { should be_directory }
      it { should be_mode 755 }
      it { should be_owned_by 'apache' }
      it { should be_grouped_into 'apache' }
    end

    describe file('/etc/httpd/conf.d/awstats.conf') do
      it { should be_file }
      it { should be_mode 644 }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      #TODO: Test content
    end

    describe command('curl http://test.localdomain/awstats') do
      its(:stdout) { should match // }
    end

    describe command('curl -L http://test.localdomain/awstats') do
      its(:stdout) { should match /Advanced Web Statistics for test.localdomain/ }
      its(:exit_status) { should eq 0 }
    end
  end
end
