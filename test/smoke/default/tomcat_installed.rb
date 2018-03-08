control 'tomcat_installed_and_running' do
  impact 1.0
  title 'Is Java and Tomcat installed, enabled, and running?'
  desc 'Verify Tomcat is installed and running'
  describe package('java-1.7.0-openjdk-devel') do
    it { should be_installed }
  end
  describe service('tomcat') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
end
