package 'nginx'

directory '/var/www/frontend' do
  owner 'www-data'
  group 'www-data'
  mode '0775'
  action :create
end

group 'www-data' do
  action :modify
  members 'ubuntu'
  append true
end

link '/etc/nginx/sites-enabled/default' do
  action :delete
  only_if 'test -L /etc/nginx/sites-enabled/default'
end

['frontend','api'].each do |vhost|
  template "/etc/nginx/sites-available/#{vhost}" do
      source "#{vhost}.erb"
      owner 'root'
      group 'root'
      mode '0644'
  end
  link "/etc/nginx/sites-enabled/#{vhost}" do
    to "/etc/nginx/sites-available/#{vhost}"
  end
end

service 'nginx' do
  action :restart
end
