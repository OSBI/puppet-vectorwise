class vectorwise::control {
	package { "libaio1":
		ensure => present,
	}
	if $::vectorwise_exists == "true" {
	  notify{"password exists":}
	  $vectorwise_password = $::vw_password
	  
	} else {
	  notify{"password doesn't exist":}
	 $vectorwise_password = generate("/usr/bin/pwgen", 20, 1)
 
	}
	 $alter_memorysize = $memorysize_mb/2
	
	     user{ "ingres":
      ensure => present,
      home => "/home/ingres",
      password => $vectorwise_password,
    } ->  file {"/home/ingres":
    ensure => directory,
    owner => ingres,
    group => ingres,
    require => User["ingres"],
  }->
	file {"/mnt/ingres":
    ensure => directory,
    owner => ingres,
    group => ingres,
    require => User["ingres"],
  }->
	    file {"/home/ingres/.vw":
      ensure => present,
      content => $vectorwise_password,
    }-> 


	file{ "/mnt/ingres/ingrsp.rsp":
		ensure => present,
		content => template("vectorwise/ingrsp.rsp.erb"),
		require => File["/mnt/ingres"],
	}
	
	file{ "/usr/bin/ingbuildscript.sh":
		ensure => present,
		source => "puppet:///modules/vectorwise/ingbuildscript.sh",
		mode => 777,		
	}
	exec { "install_ingres":
    command => "ingbuildscript.sh",
    creates => "/mnt/ingres/ingres/lib/libx100.so.0",
    require => [File["/usr/bin/ingbuildscript.sh"], File["/mnt/ingres/ingrsp.rsp"], Common::Downloadfile["ingresvw-2.0.2-121-NPTL-com-linux-ingbuild-x86_64.tgz"]],
    user => "ingres",
	}
	
	exec { "sort out passwords":
    command => "/mnt/ingres/ingres/bin/mkvalidpw ; touch /etc/passwordset",
    creates => "/etc/passwordset",
    require => [File["/usr/bin/ingbuildscript.sh"], File["/mnt/ingres/ingrsp.rsp"], Common::Downloadfile["ingresvw-2.0.2-121-NPTL-com-linux-ingbuild-x86_64.tgz"], Exec["install_ingres"]],
    user => "root",
    path    => "/usr/bin/:/bin/:/mnt/ingres/ingres/bin:/mnt/ingres/ingres/utility",
    environment => "II_SYSTEM=/mnt/ingres",
    
	}
	
	common::downloadfile { "ingresvw-2.0.2-121-NPTL-com-linux-ingbuild-x86_64.tgz" :
		site => "http://analytical-labs.com",
		cwd => "/mnt/ingres",
		creates => "/mnt/ingres/ingresvw-2.0.2-121-NPTL-com-linux-ingbuild-x86_64.tgz",
		user => "ingres",
		require => File["/mnt/ingres"],
	}
	
	file{ "/etc/init.d/vectorwise":
		ensure => present,
		source => "puppet:///modules/vectorwise/vectorwise_init",
		mode => 770,
	}
	
	service{ "vectorwise":
		ensure => running,
		enable => true,
		hasstatus => true,
		hasrestart => true,
		require => [Exec["sort out passwords"], File["/etc/init.d/vectorwise"], Package["libaio1"]],
	}
}