define vectorwise::database($ensure=present){
	exec { "create database":
		environment => "II_SYSTEM=/home/ingres",
		command => "createdb $name",
    	path    => "/usr/bin/:/bin/:/home/ingres/ingres/bin:/home/ingres/ingres/utility",
    	creates => "/home/ingres/ingres/work/default/$name"
	}
}