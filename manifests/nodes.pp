node 'app' {
  include nginx
  include redis
  include mongodb
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
    ensure   => present,
    www_root => '/var/www/jieqoo.com',
    listen_port => '80',
  }
  nginx::resource::location { 'jieqoo.com-faye':
    ensure   => present,
    proxy    => 'http://faye',
    location => '/faye',
    vhost    => 'jieqoo.com',
  }
}