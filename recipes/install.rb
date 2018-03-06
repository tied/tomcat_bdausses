#
# Cookbook:: tomcat_bdausses
# Recipe:: install
#
# Copyright:: 2018, The Authors, All Rights Reserved.

# Verify RHEL based distro
# raise if node['platform_family'] != 'rhel'
unless node['platform_family'] == 'rhel'
  Chef::Log.fatal('This cookbook is intended for RHEL based distributions')
  Chef::Log.fatal("only, but this node is based on #{node[:platform_family]}.")
  Chef::Log.fatal('Exiting...')
  raise
end

# Install Java
# Note: You could use the community Java cookbook for this but the instructions stated:
# "Use the Chef Resources Reference to find the most appropriate Chef resources to use for each task"
package 'java-1.7.0-openjdk-devel'

# Create tomcat user
user 'tomcat' do
  manage_home false
  comment 'Apache Tomcat service account'
  home '/opt/tomcat'
end

# Guard around this install routine as we only want to run this at the initial setup.
unless ::File.exist?'/opt/tomcat'
  # Download tomcat binary
  remote_file '/tmp/apache-tomcat-8.5.28.tar.gz' do
    source 'https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.28/bin/apache-tomcat-8.5.28.tar.gz'
    owner 'tomcat'
    group 'tomcat'
    mode '0644'
    action :create
  end

  # Create tomcat directory
  directory '/opt/tomcat' do
    owner 'tomcat'
    group 'tomcat'
    mode '0755'
    action :create
  end

  # Extract the Tomcat Binary
  execute 'extract_tarball' do
    command 'tar xvf /tmp/apache-tomcat-8.5.28.tar.gz -C /opt/tomcat --strip-components=1'
  end

  # Update permissions on Tomcat files
  bash 'update_permissions' do
    cwd '/opt/tomcat'
    code <<-EOS
      chgrp -R tomcat /opt/tomcat
      chmod -R g+r conf
      chmod g+x conf
      chown -R tomcat webapps/ work/ temp/ logs/
      EOS
  end
end

# Install systemd unit file
template '/etc/systemd/system/tomcat.service' do
  source 'tomcat.service.erb'
  owner 'root'
  group 'root'
  mode '0755'
end

# Reload systemd
execute 'systemd_reload' do
  command 'systemctl daemon-reload'
  action :run
end

# Start and enable Tomcat
service 'tomcat' do
  action [:enable, :start]
end
