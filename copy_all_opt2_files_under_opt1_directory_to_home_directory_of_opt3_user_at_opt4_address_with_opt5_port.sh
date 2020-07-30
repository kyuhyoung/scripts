# usage (with port option) : sh copy_all_opt2_files_under_opt1_directory_to_home_directory_of_opt3_user_at_opt4_address_with_opt5_port.sh img_*.txt $PWD kevin 14.49.45.13 16022
# usage (wthout port option) : sh copy_all_opt2_files_under_opt1_directory_to_home_directory_of_opt3_user_at_opt4_address_with_opt5_port.sh img_*.txt $PWD kevin 14.49.45.13
DIR_FROM=$1
FILES_OR_FOLDERS_2_BE_COPIED=$2
ID_REMOTE=$3
IP_REMOTE=$4
cd $DIR_FROM
if [ "$#" -eq 5 ]; then 
PORT_REMOTE=$5
tar czf - $FILES_OR_FOLDERS_2_BE_COPIED | ssh $ID_REMOTE@$IP_REMOTE -p $PORT_REMOTE "cd ~/; tar xvzm" 
else
tar czf - $FILES_OR_FOLDERS_2_BE_COPIED | ssh $ID_REMOTE@$IP_REMOTE "cd ~/; tar xvzm" 
fi
