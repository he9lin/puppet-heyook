node 'app' {
  include stdlib
  include nginx
  include redis
  include nodejs
  include railsapp
  
  railsapp::resource::location { $app_name: }
  
  if $database_type == 'mongodb' {
    include mongodb
  } else {
    include mysql
    include mysql::ruby
  }
  
  ## Nginx Configurations.
    
  nginx::resource::upstream { 'rails_server':
      ensure  => present,
      members => [
        'localhost:3000',
      ],
  }
  
  nginx::resource::vhost { $app_name:
    ensure      => present,
    www_root    => "/var/www/$app_name/current/public",
    listen_port => '80',
  }

  nginx::resource::location { "$app_name rails-server":
    ensure   => present,
    proxy    => 'http://rails_server',
    location => '@rails_server',
    vhost    => $app_name,
  }
  
  nginx::resource::upstream { 'faye':
      ensure  => present,
      members => [
        'localhost:9292',
      ],
  }
  
  nginx::resource::location { "$app_name faye":
    ensure   => present,
    proxy    => 'http://faye',
    location => '/faye',
    vhost    => $app_name,
  }

  ## Mysql stuff TODOs:
  #
  # Install Mysql server and setup a root user
  #
  # class { 'mysql::server':
  #   config_hash => {'root_password' => 'YOUR_PASSWORD'}
  # }

  # Need to set your password here: /etc/mysql/my.cnf
  #
  # [client]
  # password        = YOUR_PASSWORD

  # Create a database and a user with specified privilege
  # 
  # mysql::db { $app_db:
  #   user     => 'vagrant',
  #   password => 'password',
  #   charset  => 'utf8',
  #   host     => 'localhost',
  #   grant    => ['all'],
  #   require  => Class['mysql::server']
  # }

  # Examples:
  #
  # database { $app_db :
  #   ensure  => present,
  #   charset => 'utf8',
  #   require => Class['mysql::server'],
  # }

  # database_user { 'vagrant@localhost':
  #   ensure        => present,
  #   password_hash => mysql_password('password'),
  #   require       => Class['mysql::server'],
  # }
}

# ssh-keygen -t rsa -C "he9lin@youremail.com"
