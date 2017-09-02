package 'httpd'

service 'httpd' do
  action [:start, :enable]
end

template '/var/www/html/index.html' do
  owner 'apache'
  group 'apache'
  variables(msg: 'shhh....')
end

%w(php php-devel php-mbstring php-gd).each do |pkg|
  package pkg
end

remote_file '/etc/php.ini' do
  mode '644'
  owner 'root'
  group 'root'
  notifies :reload, 'service[httpd]'
end

remote_file '/var/www/html/index.php'

# only_if コマンド: コマンドが成功した場合に実行する
# not_if  コマンド: コマンドが失敗した場合に実行する

execute 'create a file' do
  # acriont :run
  command 'echo hello > /home/anzii/hello.txt'
  user 'anzii'
  not_if 'test -e /home/anzii/hello.txt'
end

file '/home/anzii/hello.txt' do
  action :edit
  block do |content|
    content.gsub!('hello', 'hello world')
  end
  only_if 'test -e /home/anzii/hello.txt'
end

# definition
define :install_start_enable_package do
  package params[:name]
  service params[:name] do
    action [:start, :enable]
  end
end

install_start_enable_package 'httpd'
