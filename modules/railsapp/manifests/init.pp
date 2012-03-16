class railsapp {
  file {
    ["/var/www/jieqoo.com/", 
     "/var/www/jieqoo.com/shared/", 
     "/var/www/jieqoo.com/shared/config/"]:
      ensure => directory,
      owner  => vagrant,
      group  => vagrant,
      mode   => 775
  }
}