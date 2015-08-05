require 'spec_helper'

describe 'nc_nginx' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts.merge!(:concat_basedir => '/dne')
        end

        let(:params) do
          { :install_dir => '/srv/www' }
        end

        context 'nc_nginx class without any parameters' do
          let(:params) { {} }
          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_class('nc_nginx::params') }
          it { is_expected.to contain_class('nc_nginx') }

          it do
            is_expected.to contain_package('git') \
              .that_comes_before('Vcsrepo[/srv/www]')
          end
          it { is_expected.to contain_class('nginx') }
          it do
            is_expected.to contain_vcsrepo('/srv/www') \
              .that_notifies('Service[nginx]') \
              .that_requires('Package[nginx]')
          end
          it { is_expected.to contain_nginx__resource__vhost('nc_nginx') }
        end
      end
    end

    context 'unsupported operating system' do
      describe 'nc_nginx class without any parameters on Solaris/Nexenta' do
        let(:facts) do
          { :osfamily => 'Solaris',
            :operatingsystem => 'Nexenta' }
        end
        it do
          expect { is_expected.to contain_package('nc_nginx') } \
            .to raise_error(Puppet::Error, /Nexenta not supported/)
        end
      end
    end
  end
end
