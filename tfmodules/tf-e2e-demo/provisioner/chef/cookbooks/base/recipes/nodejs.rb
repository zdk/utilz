
execute 'add_nodesource_repo' do
  command 'curl -sL https://deb.nodesource.com/setup_10.x | bash -'
  user 'root'
end

package 'nodejs'
