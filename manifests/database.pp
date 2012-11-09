define vectorwise::database($ensure=present){
	exec { "create database":
		environment => "II_SYSTEM=/mnt/ingres",
		command => "createdb $name",
    	path    => "/usr/bin/:/bin/:/mnt/ingres/ingres/bin:/mnt/ingres/ingres/utility",
    	creates => "/mnt/ingres/ingres/work/default/$name",
    	user => "ingres",
    	require => Service["vectorwise"],
	}
	

}