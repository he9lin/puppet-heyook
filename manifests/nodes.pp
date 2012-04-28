node 'app' {
  include stdlib
  include nginx
  include redis
  include mongodb
  include nodejs
  include railsapp

  $app_name = 'jieqoo.com'
  
  railsapp::resource::location { $app_name: }
    
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
