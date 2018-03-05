#
# Cookbook:: tomcat_bdausses
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

# Install Java
package 'java-1.7.0-openjdk-devel'

# Create tomcat user
user 'tomcat' do
  manage_home false
  comment 'Apache Tomcat service account'
  home '/opt/tomcat'
end

# Download tomcat binary
remote_file '/tmp/apache-tomcat-8.5.28.tar.gz' do
  source 'https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.28/bin/apache-tomcat-8.5.28.zip'
  owner 'tomcat'
  group 'tomcat'
  mode '0644'
  action :create
end

# Create tomcat directory
directory '/opt/tomcat'
  owner 'tomcat'
  group 'tomcat'
  mode '0755'
  action :create
end
