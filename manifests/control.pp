class vectorwise::control {
	
	user{ "ingres":
		ensure => present,
	}
	
	file{ "/home/ingres/ingrsp.rsp":
		ensure => present,
		content => template("ingrsp.rsp.erb"),
		require => User["ingres"],
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
		require => User["ingres"],
	}
	
}