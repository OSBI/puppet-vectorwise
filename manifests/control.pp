class vectorwise::control {
	package { "libaio1":
		ensure => present,
	}
	user{ "ingres":
		ensure => present,
		home => "/home/ingres",
		password => '$6$0phZG4.3$3Ep9Rl.A3KcRPqPtVbGbwM5sSNG4DAvDAdjlqL8dbal6AsGQP6qccTNUmdDUpY251FRtL7p0GbkuOFAx7p4gW1',
	}
	
	file {"/home/ingres":
		ensure => directory,
		owner => ingres,
		group => ingres,
		require => User["ingres"],
	}
	file{ "/home/ingres/ingrsp.rsp":
		ensure => present,
		content => template("vectorwise/ingrsp.rsp.erb"),
		require => File["/home/ingres"],
	}
	
	file{ "/usr/bin/ingbuildscript.sh":
		ensure => present,
		source => "puppet:///modules/vectorwise/ingbuildscript.sh",
		mode => 777,		
	}
	exec { "install_ingres":
    command => "ingbuildscript.sh",
    creates => "/home/ingres/ingres/lib/libx100.so.0",
    require => [File["/usr/bin/ingbuildscript.sh"], File["/home/ingres/ingrsp.rsp"], Common::Downloadfile["ingresvw-2.0.2-121-NPTL-com-linux-ingbuild-x86_64.tgz"]],
    user => "ingres",
	}
	
	exec { "sort out passwords":
    command => "/home/ingres/ingres/bin/mkvalidpw ; touch /etc/passwordset",
    creates => "/etc/passwordset",
    require => [File["/usr/bin/ingbuildscript.sh"], File["/home/ingres/ingrsp.rsp"], Common::Downloadfile["ingresvw-2.0.2-121-NPTL-com-linux-ingbuild-x86_64.tgz"]],
    user => "root",
    path    => "/usr/bin/:/bin/:/home/ingres/ingres/bin:/home/ingres/ingres/utility",
    environment => "II_SYSTEM=/home/ingres",
    
	}
	
	common::downloadfile { "ingresvw-2.0.2-121-NPTL-com-linux-ingbuild-x86_64.tgz" :
		site => "http://analytical-labs.com",
		cwd => "/home/ingres",
		creates => "/home/ingres/ingresvw-2.0.2-121-NPTL-com-linux-ingbuild-x86_64.tgz",
		user => "ingres",
		require => File["/home/ingres"],
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
		require => [Exec["sort out passwords"], File["/etc/init.d/vectorwise"]],
	}
}