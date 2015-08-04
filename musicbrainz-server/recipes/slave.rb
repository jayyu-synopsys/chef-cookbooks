include_recipe "musicbrainz-server::install"

package "nodejs"
package "nodejs-legacy"
package "npm"
package "libtemplate-plugin-json-escape-perl"

execute "npm_install" do
  cwd "/home/musicbrainz/musicbrainz-server"
  command "npm install"
#  ignore_failure true
  action :run
end

execute "compile_resources" do
  cwd "/home/musicbrainz/musicbrainz-server/script"
  command "./compile_resources.pl"
  action :run
end

service "redis6379" do
  action [:start,:enable]
end

directory "/home/musicbrainz/bin" do
  owner "musicbrainz"
  group "musicbrainz"
  mode "0755"
  action :create
end

directory "/home/musicbrainz/lock" do
  owner "musicbrainz"
  group "musicbrainz"
  mode "0755"
  action :create
end

cookbook_file "/home/musicbrainz/bin/replicate" do
  source "replicate"
  group "musicbrainz"
  owner "musicbrainz"
  mode "0755"
end

cookbook_file "/home/musicbrainz/bin/check-replication-lock" do
  source "check-replication-lock"
  group "musicbrainz"
  owner "musicbrainz"
  mode "0755"
end

cookbook_file "/home/musicbrainz/lock/no-background-replication.lock" do
  source "no-background-replication.lock"
  group "musicbrainz"
  owner "musicbrainz"
  mode "0755"
end

cron "replicate" do
  minute "15"
  command "perl /home/musicbrainz/bin/check-replication-lock"
  action :create
  user "musicbrainz"
end
