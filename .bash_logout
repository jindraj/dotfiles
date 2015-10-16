# Remove mysql/psql history files
[[ -s ~/.mysql_history ]] && rm ~/.mysql_history
[[ -s ~/.psql_history ]] && rm ~/.psql_history
[ "$TERM" != "screen-256color" ] && clear
# delete sudo timestamps
sudo -k 
# append bash_history to history file
history -a
