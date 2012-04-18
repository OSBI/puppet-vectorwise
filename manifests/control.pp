class vectorwise::control {
	
	user{ "ingres":
		ensure => present,
		home => "/home/ingres",
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
		mode => 766,		
	}
	exec { "install_ingres":
    command => "ingbuildscript.sh",
    creates => "/home/ingres/ingres/lib/libx100.so.0",
    require => [File["/usr/bin/ingbuildscript.sh"], File["/home/ingres/ingrsp.rsp"], Common::Downloadfile["ingresvw-2.0.2-121-NPTL-com-linux-ingbuild-x86_64.tgz"]]
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
		require => [Exec["install_ingres"], File["/etc/init.d/vectorwise"]],
	}
}