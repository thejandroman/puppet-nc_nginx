require 'spec_helper_acceptance'

describe 'nc_nginx class' do
  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work idempotently with no errors' do
      pp = <<-EOS
      class { 'nc_nginx': }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe port(8000) do
      it { is_expected.to be_listening.with('tcp') }
    end

    describe command('curl http://localhost:8000/') do
      its(:stdout) { is_expected.to match /PSE Exercise/ }
      its(:exit_status) { is_expected.to eq 0 }
    end

    describe process('nginx') do
      it { is_expected.to be_running }
    end

    describe package('nginx') do
      it { is_expected.to be_installed }
    end

    describe service('nginx') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
  end
end
