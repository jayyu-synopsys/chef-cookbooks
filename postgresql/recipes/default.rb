package "postgresql-9.3"
package "postgresql-contrib-9.3"

apt_repository "musicbrainz" do
  uri "http://ppa.launchpad.net/metabrainz/musicbrainz-server/ubuntu"
  distribution node['lsb']['codename']
  components ["main"]
  keyserver "keyserver.ubuntu.com"
  key "E3446F96A3FB3557"
end

package "postgresql-musicbrainz-collate"
package "postgresql-musicbrainz-unaccent"

cookbook_file "/etc/postgresql/9.3/main/pg_hba.conf" do
  source "pg_hba.conf"
  owner "postgres"
end

cookbook_file "/etc/postgresql/9.3/main/postgresql.conf.in" do
  source "postgresql.conf.in"
  owner "postgres"
  group "postgres"
  mode "0644"
end

cookbook_file "/etc/init.d/postgresql-config" do
  source "postgresql-config"
  owner "root"
  group "root"
  mode "0755"
end

link "/etc/rc2.d/S18postgresql-config" do
  to "/etc/init.d/postgresql-config"
end

link "/etc/rc3.d/S18postgresql-config" do
  to "/etc/init.d/postgresql-config"
end

file "/etc/postgresql/9.3/main/postgresql.conf" do
  action :delete
end

cookbook_file "/usr/local/bin/tune_pg.py" do
  source "tune_pg.py"
  owner "root"
  group "root"
  mode "0755"
end

service "postgresql-config" do
  action [ :start ]
end

service "postgresql" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start, :reload ]
end
