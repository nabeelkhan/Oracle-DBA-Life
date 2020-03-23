#!/usr/bin/ksh

# dsm - display shared memory - displays all of the oracle user's shared memory
# segments and semsphores on a system, along with the instance that owns each
# segment and semaphore. This command can be run in one of two ways: it can 
# either be run on a per-instance basis, or it can be run on a system-wide 
# basis. If it is run on a per-instance basis, the script will display the IDs 
# of the segments and semaphores that that particular instance owns. If it is 
# run on a system-wide basis, then the script will look at each of the shared 
# memory segments and semaphores on the system that were started by the oracle 
# account, and try to figure out which oracle instance owns each segment or 
# semaphore. If the script cannot identify which instance owns a particular 
# segment or semaphore, then it will list the instance owner as "Unknown". The 
# main reason why the script would not be able to identify the owner of a 
# segment or semaphore is if that segment or semaphore was left running after a
# kill -9 was run on its instance's background processes.
#
# The way to run this script on a per-instance basis is to specify a particular
# instance name as the first argument to the script. The way to run it on a 
# system-wide basis is to specify either the string "ALL" or the string "TIDY"
# as the first argument to the script. If you specify the string ALL, the 
# script will display the string "Unknown" next to a segment or semaphore, if 
# that segment or semaphore's owner cannot be identified (as mentioned above).
# If you specify the string TIDY, the script will try to determine if there are
# any orphaned shared memory segments or semaphores on the system currently -
# and if there are, the script will try to REMOVE those segments and 
# semaphores automatically. 
#
# This script was created by Brian Keating. He can be contacted at 
# briankeating@juno.com

if (($# != 1)); then
  print "Usage: dsm <instance name|ALL|TIDY>"
  exit 1
fi

export PATH=$PATH:/usr/local/bin
export ORAENV_ASK=NO

cd /tmp
mkdir shmem$$
cd shmem$$

check_status() {

  ps -ef | grep ora_pmon_${ORACLE_SID}\$ >/dev/null 2>&1
  if (($? == 0)); then
    return 0
  else
    return 1
  fi

}  
    
gen_trace() {

  ora_9i_flag=0

  if [ -f $ORACLE_HOME/bin/svrmgrl ]; then

    svrmgrl <<EOF >/dev/null 2>&1
      connect internal
      spool ${ORACLE_SID}
      select value from v\$parameter where name = 'user_dump_dest';
      spool off
      spool ipc
      oradebug ipc
EOF

  else # this must be a 9i database

    ora_9i_flag=1

    sqlplus -s /nolog <<EOF >/dev/null 2>&1
      connect / as sysdba
      set pagesize 0
      set heading off
      set feedback off
      spool ${ORACLE_SID}.log
      select value from v\$parameter where name = 'user_dump_dest';
      spool off
      spool ipc.log
      oradebug setmypid
      oradebug ipc
EOF

  fi

  if (($ora_9i_flag == 0)); then

    format_flag=0

    grep "[Ii]nformation written to trace file" ipc.log >/dev/null 2>&1

    if (($? == 0)); then
      cat ${ORACLE_SID}.log | awk '{print $1}' >${ORACLE_SID}.udump
      udump_dir=`sed -n 3p ${ORACLE_SID}.udump`
      cd ${udump_dir}
      udump_file=`grep -l Shmid \`ls -tr | tail -3\` | tail -1`
      cd -
      cp ${udump_dir}/${udump_file} .
    fi
  
    grep "Information written to trace file" ipc.log >/dev/null 2>&1
  
    if (($? == 0)); then
      format_flag=1 # 8.1.X style format
    fi
  
    grep "Shared memory information written to trace file" ipc.log >/dev/null 2>&1
    
    if (($? == 0)); then
  
      grep "Subarea size     Segment size\$" ${udump_file} >/dev/null 2>&1
  
      if (($? == 0)); then
        format_flag=2 # 8.0.6 style format
        mem_file=${udump_file}
        mem_string=Shmid
        mem_lines=1
        mem_col=3
      else
        format_flag=3 # 8.0.5 style format
        mem_file=${udump_file}
        mem_string=Shmid
        mem_lines=2
        mem_col=3
      fi
  
    fi
  
    if (($format_flag == 0)); then
  
      grep Shmid ipc.log >/dev/null 2>&1
  
      if (($? == 0)); then
        format_flag=4 # 8.0.4 style format
        mem_file=ipc.log
        mem_string=Shmid
        mem_lines=1
        mem_col=2
      else
        format_flag=5 # 7.3.4 style format
        mem_file=ipc.log
        mem_string="Seg Id"
        mem_lines=1
        mem_col=1
      fi
  
    fi 
    
    if (($format_flag == 1)); then
  
      # get shared memory segment IDs from the trace file
  
      for cur_line in `grep -n Shmid ${udump_file} | awk -F: '{print $1}'`; do
        (( check_line = ${cur_line} + 1 ))
        sed -n ${check_line}p ${udump_file} | awk '{print $3}' >>${ORACLE_SID}_temp
      done
      grep [0-9] ${ORACLE_SID}_temp | sort -n | uniq >${ORACLE_SID}_shmids
      
      # get semaphore IDs from the trace file
  
      upper_bound=`grep -n "Semaphore List=" ${udump_file} | awk -F: '{print $1}'`
      lower_bound=`grep -n "system semaphore information" ${udump_file} | awk -F: '{print $1}'`
  
      (( first_line = $upper_bound + 1 ))
      (( last_line = $lower_bound - 1 ))
  
      sed -n ${first_line},${last_line}p ${udump_file} | awk '{print $1}' >${ORACLE_SID}_semids
  
    else
  
      # get shared memory segment IDs from the appropriate file
  
      for cur_line in `grep -n "${mem_string}" ${mem_file} | awk -F: '{print $1}'`; do
        (( check_line = ${cur_line} + ${mem_lines} ))
        sed -n ${check_line}p ${mem_file} | awk '{print $'$mem_col'}' >>${ORACLE_SID}_temp
      done
      grep [0-9] ${ORACLE_SID}_temp | sort -n | uniq >${ORACLE_SID}_shmids
      
      # get semaphore IDs from the file "ipc.log"
  
      upper_bound=`grep -n "Semaphore identifiers:" ipc.log | awk -F: '{print $1}'`
      (( first_line = $upper_bound + 1 ))
      sed -n ${first_line},\$p ipc.log | awk '{print $1}' >${ORACLE_SID}_semids
  
    fi
    
  else # 9i-specific logic

    cat ${ORACLE_SID}.log | awk '{print $1}' >${ORACLE_SID}.udump
    udump_dir=`sed -n 1p ${ORACLE_SID}.udump`
    cd ${udump_dir}
    udump_file=`grep -l Shmid \`ls -tr | tail -3\` | tail -1`
    cd -
    cp ${udump_dir}/${udump_file} .

    # get shared memory segment IDs from the trace file
  
    for cur_line in `grep -n Shmid ${udump_file} | awk -F: '{print $1}'`; do
      (( check_line = ${cur_line} + 1 ))
      sed -n ${check_line}p ${udump_file} | awk '{print $3}' >>${ORACLE_SID}_temp
    done
    grep [0-9] ${ORACLE_SID}_temp | sort -n | uniq >${ORACLE_SID}_shmids
    
    # get semaphore IDs from the trace file

    upper_bound=`grep -n "Semaphore List=" ${udump_file} | awk -F: '{print $1}'`
    lower_bound=`grep -n "system semaphore information" ${udump_file} | awk -F: '{print $1}'`

    (( first_line = $upper_bound + 1 ))
    (( last_line = $lower_bound - 1 ))

    sed -n ${first_line},${last_line}p ${udump_file} | awk '{print $1}' >${ORACLE_SID}_semids

  fi

  rm -f ${ORACLE_SID}.log >/dev/null 2>&1
  rm -f ${ORACLE_SID}.udump >/dev/null 2>&1
  rm -f ${ORACLE_SID}.bdump >/dev/null 2>&1
  rm -f ${ORACLE_SID}_temp >/dev/null 2>&1
  rm -f ${udump_file} >/dev/null 2>&1
  rm -f ${bdump_file} >/dev/null 2>&1
  rm -f ipc.log >/dev/null 2>&1

}

# main program

if [[ $1 = "ALL" ]] || [[ $1 = "TIDY" ]]; then

  print -n "Dumping instance ipc information..."

  for curr_instance in `cat /etc/oratab | egrep -v "^#|^\*" | awk -F: '{print $1}'`
  do

    owner=`ps -ef | grep ora_pmon_${curr_instance}\$ | grep -v grep | awk '{print $1}'`

    if [[ $owner != "oracle" ]]; then
      # Either this instance is not running, or it is not owned by the oracle
      # account. So, skip this instance.
      continue
    fi

    export ORACLE_SID=$curr_instance
    . oraenv

    check_status $ORACLE_SID

    if (($? == 0)); then
      gen_trace $ORACLE_SID
      print -n "."
    fi
  done

  print "done"

  ipcs -m | grep " oracle " | grep -v " D" | sort -n | awk -Fm '{print $2}' | awk '{print $1}' >ipc_shm.out
  ipcs -s | grep " oracle " | grep -v " D" | sort -n | awk -Fs '{print $2}' | awk '{print $1}' >ipc_sem.out

  if [[ $1 = "TIDY" ]]; then

    print -n "\nChecking for orphaned shared memory segments..."

    >orphaned_segs

    for curr_id in `cat ipc_shm.out`; do
      file=`grep -lx $curr_id *_shmids`
      instance=`echo $file | awk -F_ '{print $1}'`
      if [[ $instance = "" ]]; then
        instance="Unknown"
        print $curr_id >>orphaned_segs
      fi
    done

    num_segs=`wc -l orphaned_segs | awk '{print $1}`

    if (($num_segs == 0)); then
      print "\nNo orphaned shared memory segments were detected."

    elif (($num_segs == 1)); then

      print "\n1 orphaned shared memory segment was detected."
      print -n "Attemting to remove the orphaned segment..."
      cur_orphan=`cat orphaned_segs` 
      ipcrm -m ${cur_orphan}
      ipcs -m | grep oracle | awk -Fm '{print $2}' | awk '{print $1}' | grep -x ${cur_orphan} >/dev/null 2>&1
      
      if (($? != 0)); then
        print "\nThe orphaned segment was removed."
      else
        print "\nERROR: the orphaned segment could not be removed!"
      fi

    else

      num_removed=0
      num_not_removed=0

      print "\n${num_segs} orphaned shared memory segments were detected."
      print -n "Attemting to remove the orphaned segments..."

      for cur_orphan in `cat orphaned_segs`; do
        ipcrm -m ${cur_orphan}
        ipcs -m | grep oracle | awk -Fm '{print $2}' | awk '{print $1}' | grep -x ${cur_orphan} >/dev/null 2>&1
        if (($? != 0)); then
          (( num_removed = $num_removed + 1 ))
        else
          (( num_not_removed = $num_not_removed + 1 ))
        fi
      done

      if (($num_not_removed == 0)); then
        print "\nAll ${num_removed} of the orphaned segments were removed."
      else
        print "\nERROR: ${num_not_removed} of the orphaned segments could not be removed."
      fi

    fi

    print -n "\nChecking for orphaned semaphores..."

    >orphaned_sems

    for curr_id in `cat ipc_sem.out`; do
      file=`grep -lx $curr_id *_semids`
      instance=`echo $file | awk -F_ '{print $1}'`
      if [[ $instance = "" ]]; then
        instance="Unknown"
        print $curr_id >>orphaned_sems
      fi
    done

    num_sems=`wc -l orphaned_sems | awk '{print $1}`

    if (($num_sems == 0)); then
      print "\nNo orphaned semaphores were detected."

    elif (($num_sems == 1)); then

      print "\n1 orphaned semaphore was detected."
      print -n "Attemting to remove the orphaned semaphore..."
      cur_orphan=`cat orphaned_sems` 
      ipcrm -s ${cur_orphan}
      ipcs -s | grep oracle | awk -Fs '{print $2}' | awk '{print $1}' | grep -x ${cur_orphan} >/dev/null 2>&1
      
      if (($? != 0)); then
        print "\nThe orphaned semaphore was removed."
      else
        print "\nERROR: the orphaned semaphore could not be removed."
      fi

    else

      num_removed=0
      num_not_removed=0

      print "${num_sems} orphaned semaphores were detected."
      print -n "Attemting to remove the orphaned semaphores..."

      for cur_orphan in `cat orphaned_sems`; do
        ipcrm -s ${cur_orphan}
        ipcs -s | grep oracle | awk -Fs '{print $2}' | awk '{print $1}' | grep -x ${cur_orphan} >/dev/null 2>&1
        if (($? == 0)); then
          (( num_removed = $num_removed + 1 ))
        else
          (( num_not_removed = $num_not_removed + 1 ))
        fi
      done

      if (($num_not_removed == 0)); then
        print "\nThe orphaned semaphores were removed."
      else
        print "\nERROR: $num_not_removed of the orphaned semaphores could not be removed."
      fi

    fi

  else
    print "Shared memory segments:\n"
    print "Segment ID:    Instance:"
    
    for curr_id in `cat ipc_shm.out`; do
      file=`grep -lx $curr_id *_shmids`
      instance=`echo $file | awk -F_ '{print $1}'`
      if [[ $instance = "" ]]; then
      instance="Unknown"
      fi
      printf "%-15s%s\n" $curr_id $instance
    done

    print "\nSemaphores:\n"
    print "Semaphore ID:    Instance:"
    
    for curr_id in `cat ipc_sem.out`; do
      file=`grep -lx $curr_id *_semids`
      instance=`echo $file | awk -F_ '{print $1}'`
      if [[ $instance = "" ]]; then
        instance="Unknown"
      fi
      printf "%-17s%s\n" $curr_id $instance
    done

  fi

  cd /tmp
  rm -rf shmem$$ >/dev/null 2>&1

else

  export ORACLE_SID=$1
  . oraenv
  
  check_status $ORACLE_SID

  if (($? == 1)); then
    print "ERROR: it appears that the $ORACLE_SID instance is not currently running!"
    print "That instance must be started before this script can be run against it."
    exit 2
  fi

  gen_trace $ORACLE_SID

  print -n "Shared memory segment IDs owned by the $ORACLE_SID instance:"
  for i in `cat ${ORACLE_SID}_shmids`; do
    print -n " $i"
  done

  print ""

  print -n "Semaphore IDs owned by the $ORACLE_SID instance:"
  for i in `cat ${ORACLE_SID}_semids`; do
    print -n " $i"
  done

  print ""

  cd /tmp
  rm -rf shmem$$ >/dev/null 2>&1

fi

