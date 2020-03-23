#!/bin/ksh

#*****************************************************************
#
# Copyright (c) 2002 by Donald K. Burleson
#
# Licensing information may be found at www.dba-oracle.com
#
#*****************************************************************

#***********************************************************
#  DO NOT customize this .profile script.
#  The directive below will allow to you add customizations
#  to the .kshrc file.  All host-specific profile customizations
#  should be placed in the .kshrc file.
#***********************************************************

ENV=.kshrc; export ENV


#***************************************************************
#  These are generic UNIX set-up commands
#***************************************************************
umask 022

DBABRV=ora; export DBABRV
ORACLE_TERM=vt100; export ORACLE_TERM
TERM=vt100; export TERM
wout=`who am i`
DISPLAY=`expr "$wout" : ".*(\([0-9]*\.[0-9]*\.[0-9]*\.[0-9]*\))"`
DISPLAY="${DISPLAY}:0"; export DISPLAY
ORAENV_ASK=NO; export ORAENV_ASK
export EDITOR=vi

PATH=$PATH:$OBK_HOME/bin:/legato/bin:/usr/lbin:/usr/sbin:.
export PATH

SQLPATH=/export/home/oracle/admin:/u01/app/oracle/admin/sql:/u01/app/oracle/admin/scripts/dba:/export/home/oracle/tools
export SQLPATH

#TNS_ADMIN=/u01/app/oracle/admin/site
#export TNS_ADMIN

#*****************************************************************
# Keyboard
#*****************************************************************
stty erase ^?
set -o vi

#*****************************************************************
# Standard UNIX Prompt
#*****************************************************************
ORACLE_SID=readtest
export ORACLE_SID

PS1="
`hostname`*\${ORACLE_SID}-\${PWD}
>"

export PS1

   TEMPHOME=`cat /var/opt/oracle/oratab|egrep ':N|:Y'|grep -v \*|cut -f2 -d':'|head -1`
   export TEMPHOME

   #*****************************************************************
   # For every Oracle_SID in /var/opt/oracle/oratab, create an alias using the SID name.
   # Now, entering the ORACLE_SID at the UNIX prompt will completely set the
   # UNIX environment for that SID
   #*****************************************************************


   for DB in `cat /var/opt/oracle/oratab|grep -v \#|grep -v \*|cut -d":" -f1`
   do
      alias $DB='export ORAENV_ASK=NO; export ORACLE_SID='$DB'; . $TEMPHOME/bin/oraenv; export ORACLE_HOME; export ORACLE_BASE=`echo $ORACLE_HOME | sed -e 's:/product/.*::g'`; export DBA=$ORACLE_BASE/admin; export SCRIPT_HOME=$DBA/scripts; export PATH=$PATH:$SCRIPT_HOME; export LIB_PATH=$ORACLE_HOME/lib64:$ORACLE_HOME/lib '
   done

   #***********************************************************
   #  Here we set a default database SID and get an ORACLE_HOME
   #***********************************************************

   ORACLE_HOME=`cat /var/opt/oracle/oratab|grep -v \#|grep -v \*|cut -d":" -f2|head -1`
   export ORACLE_HOME
   ORACLE_BASE=`echo $ORACLE_HOME | sed -e 's:/product/.*::g'`
   export ORACLE_BASE
   DBA=$ORACLE_BASE
   export DBA
   PATH=$PATH:$ORACLE_HOME/bin:$ORACLE_HOME:/usr/ccs/bin:/usr/local/bin:/usr/ucb:/export/home/oracle/tools
   export PATH

   ORACLE_SID=`cat /var/opt/oracle/oratab|grep -v \#|grep -v \*|cut -d":" -f1|head -1`
   export ORACLE_SID

#PATH=$PATH:$ORACLE_HOME/bin:$ORACLE_HOME:/usr/ccs/bin:/usr/ucb:/usr/include
   #
   # Aliases
   #
   alias tools='cd /export/home/oracle/tools'
   alias listbk='ls /export/home/oracle/book/Chapter8'
   alias table='cd $DBA/$ORACLE_SID/ddl/tables'
   alias index='cd $DBA/$ORACLE_SID/ddl/indexes'
   alias plsql='cd $DBA/$ORACLE_SID/ddl/plsql'
   alias ts='cd $DBA/$ORACLE_SID/ddl/tablespaces'
   alias precomp='cd $ORACLE_HOME/precomp/demo/proc/terrydir'
   alias alert='tail -100 $DBA/$ORACLE_SID/bdump/alert_$ORACLE_SID.log|more'
   alias arch='cd $DBA/$ORACLE_SID/arch'
   alias bdump='cd $DBA/$ORACLE_SID/bdump'
   alias cdump='cd $DBA/$ORACLE_SID/cdump'
   alias pfile='cd $DBA/$ORACLE_SID/pfile'
   alias udump='cd $DBA/$ORACLE_SID/udump'
   alias arsd='cd $DBA/$ORACLE_SID/arsd'
   alias rm='rm -i'
   alias sid='env|grep -i sid'
   alias admin='cd $DBA/admin'
   alias logbook='/u01/app/oracle/admin/$ORACLE_SID/logbook'


NLS_LANG='english_united kingdom.we8iso8859p1'
ORA_NLS33=$ORACLE_HOME/ocommon/nls/admin/data
ORACLE_TERM=vt100
LD_LIBRARY_PATH=/usr/lib:$ORACLE_HOME/lib64:$ORACLE_HOME/lib
PATH=$PATH:$ORACLE_HOME/bin
export NLS_LANG ORA_NLS33 PATH LD_LIBRARY_PATH

export JAVA_HOME=/usr/local/jre
export PATH=$JAVA_HOME/bin:$PATH

#readprod
readtest
