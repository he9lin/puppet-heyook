node 'app' {
  include stdlib
  include nginx
  include redis
  # include mongodb
  include nodejs
  include railsapp

  $app_name = 'jieqoo.com'
  $app_db   = 'jieqoo_production'
  
  railsapp::resource::location { $app_name: }
  
  
  
  ## Mysql stuff
  
  include mysql
  include mysql::ruby
  
  # Need to set your password here: /etc/mysql/my.cnf
  # [client]
  # password        = YOUR_PASSWORD
  
  class { 'mysql::server':
    config_hash => {'root_password' => 'KassJieqoo4ever'}
  }
  
  mysql::db { $app_db:
    user     => 'vagrant',
    password => 'Kass4ever',
    charset  => 'utf8',
    host     => 'localhost',
    grant    => ['all'],
    require  => Class['mysql::server']
  }

  # database { $app_db :
  #   ensure  => present,
  #   charset => 'utf8',
  #   require => Class['mysql::server'],
  # }

  # database_user { 'vagrant@localhost':
  #   ensure        => present,
  #   password_hash => mysql_password('Kass4ever'),
  #   require       => Class['mysql::server'],
  # }
  
  
  
  ## Nginx stuff
    
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

  nginx::resource::location { "#{$app_name}-rails-server":
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
  
  nginx::resource::location { "#{$app_name}-faye":
    ensure   => present,
    proxy    => 'http://faye',
    location => '/faye',
    vhost    => $app_name,
  }
}

# ssh-keygen -t rsa -C "he9lin@youremail.com"
