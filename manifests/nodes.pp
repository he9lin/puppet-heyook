node 'app' {
  include stdlib
  include nginx
  include redis
  include mongodb
  include nodejs
  include railsapp

  nginx::resource::upstream { 'thin':
      ensure  => present,
      members => [
        'localhost:3000',
      ],
  }
  
  nginx::resource::upstream { 'faye':
      ensure  => present,
      members => [
        'localhost:9292',
      ],
  }
  
  nginx::resource::vhost { 'jieqoo.com':
    ensure      => present,
    www_root    => '/var/www/jieqoo.com/current/public',
    listen_port => '80',
  }

  # Use a variable for thin
  nginx::resource::location { 'jieqoo.com-thin':
    ensure   => present,
    proxy    => 'http://thin',
    location => '@thin',
    vhost    => 'jieqoo.com',
  }
  
  nginx::resource::location { 'jieqoo.com-faye':
    ensure   => present,
    proxy    => 'http://faye',
    location => '/faye',
    vhost    => 'jieqoo.com',
  }
}

# ssh-keygen -t rsa -C "he9lin@youremail.com"
