# Remove mysql/psql history files
#[[ -s ~/.mysql_history ]] && rm ~/.mysql_history
#[[ -s ~/.psql_history ]] && rm ~/.psql_history

# clear screen
[[ "$TERM" != "screen-256color" ]] && clear

sudo -k    # delete sudo timestamps
history -a # append bash_history to history file
