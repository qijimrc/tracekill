#!/bin/bash

# $1: pid

STPFile="sigmon.stp"

cat>$STPFile<<EOF
probe begin
{
  printf("%-8s %-16s %-5s %-16s %6s %-16s\n",
         "SPID", "SNAME", "RPID", "RNAME", "SIGNUM", "SIGNAME")
}

probe signal.send 
{
  if (sig_name == @1 && sig_pid == target())
    printf("%-8d %-16s %-5d %-16s %-6d %-16s\n", 
      pid(), execname(), sig_pid, pid_name, sig, sig_name)
}
EOF

nohup stap -x $1 $STPFile SIGKILL >> tracekill.log &
