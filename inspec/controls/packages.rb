# encoding: utf-8

title 'packages'

control 'packages-00' do
  impact 1.0
  title "Git"

  describe package("git") do
    it { should be_installed }
    its('version') { should match %r{^2\.\d+\.\d} }
  end
end

control 'packages-01' do
  impact 1.0
  title "OpenSSH and OpenSSL"

  describe command('ssh -V') do
    its('exit_status') { should eq 0 }
    its('stderr') { should match(%r{OpenSSH_8\.\d}) }
    its('stderr') { should match(%r{OpenSSL 1\.\d+\.\d}) }
  end
end

control 'packages-02' do
  impact 1.0
  title "Bash"

  describe package("bash") do
    it { should be_installed }
    its('version') { should match %r{^5\.\d+.\d} }
  end
end