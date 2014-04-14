# /etc/skel/.bash_logout
# This file is sourced when a login shell terminates.

# Clear the screen for security's sake.
[[ -s ~/.mysql_history ]] && rm ~/.mysql_history
[[ -s ~/.psql_history ]] && rm ~/.psql_history
clear
