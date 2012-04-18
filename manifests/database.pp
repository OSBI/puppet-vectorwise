define vectorwise::database($ensure=present){
	exec { "create database":
		command => "II_SYSTEM=/home/ingres createdb $name",
    	path    => "/usr/bin/:/bin/:/home/ingres/ingres/bin:/home/ingres/ingres/utility",
    	creates => "/home/ingres/ingres/work/default/$name"
	}
}