define railsapp::resource::location {
  file {
    ["/var/www/${name}/", 
     "/var/www/${name}/shared/", 
     "/var/www/${name}/shared/config/"]:
       ensure => directory,
       owner  => vagrant,
       group  => vagrant,
       mode   => 775
  }

  file { "/var/www/${name}/shared/config/database.yml":
    ensure  => present,
    owner   => vagrant,
    group   => vagrant,
    mode    => 600,
    content => template("railsapp/database.yml")
  }
}
