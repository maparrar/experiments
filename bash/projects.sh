#!/bin/bash
# maparrar@gmail.com
# https://github.com/maparrar/devel
# 2018-02-20

echo "========================================================="
echo "DEVEL - Development tool"

# Parameters
START=$(date +%s.%N)
res='==> '

# Parameters
#data_dir="/var/lib/postgresql/"$ver

# Show messages in terminal and notify system (install: sudo apt install notify-osd)
function mymessage {
   echo $1;
   notify-send PHYSQL "$1" -t 10000
}

# show help message
function myhelp {
	echo "Tool for manage development projects"
	echo "Use:"
	echo "Install"
	echo "$ devel init PROJECT_NAME"
	echo "Initialization and setup of the folder project"
	echo "$ devel init PROJECT_NAME"
	#echo "Restore a snapshot of the databases"
	#echo "$ ./physql restore [dirname]"
}

if [ ! -z "$2" ]; then
	if [ "$1" = 'snapshot' ]; then
		mymessage "$res Stopping PostgreSQL"
		sudo service postgresql stop
		
		mymessage "$res Creating physical copy of PostgreSQL"
		sudo rsync -ar $data_dir"/main" $2
		sudo rsync -ar $data_dir"/main" $2
		sudo rsync -ar $data_dir"/main" $2
		
		mymessage "$res Restarting PostgreSQL"
		sudo service postgresql start
		
		mymessage "$res Physical copy finished: "$2
	elif [ "$1" = 'restore' ]; then
		if [ -d "$2" ]; then
			mymessage "$res Stopping PostgreSQL server"
			sudo service postgresql stop;
			if [ -f $data_dir"/main/postmaster.pid" ]; then
			    sudo su postgres -c $bin_dir"/bin/pg_ctl -D "$data_dir"/main stop"
			fi
			
			# Three times because once cannot overwrite the current database
			mymessage "$res Restoring physical copy of PostgreSQL"
			sudo rsync -ar $2/main $data_dir
			sudo rsync -ar $2/main $data_dir
			sudo rsync -ar $2/main $data_dir
			
			mymessage "$res Restarting PostgreSQL"
			if [ -f $data_dir"/main/postmaster.pid" ]; then
				sudo rm -f $data_dir"/main/postmaster.pid"
			fi
			# Restarting the PostgreSQL server and the main cluster
			sudo su postgres -c $bin_dir"/bin/pg_resetxlog "$data_dir"/main"
			sudo service postgresql start
			sudo pg_ctlcluster $ver main start
			
			mymessage "$res Restore finished"
		fi
	else
		myhelp
	fi
else
	myhelp
fi

# Elapsed time
END=$(date +%s.%N)
DIFF=$(echo "$END - $START" | bc)
echo "$res Running time: $DIFF seconds"
echo "_________________________________________________________"
echo ""
