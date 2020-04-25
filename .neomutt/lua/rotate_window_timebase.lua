base = { "hour", "day", "week", "month", "year" }
for k,v in pairs(base) do
  if v == mutt.get('nm_query_window_timebase') then
    i=(k+1)%(#base+1) -- because LUA counts from 1
    if i==0 then i=1 end -- don't know if this can be done better
    break
  end
end
-- set the value
mutt.set('nm_query_window_timebase',base[i])
-- source file where the status_format is to
mutt.enter("source ~/.neomutt/neomuttrc.profile-common")
-- reopen current mailbox to force rerun the query (possible neomutt bug?)
mutt.command.push('c^^\\n')
-- inform me
mutt.call("echo","'Changing window base to '" .. base[i])
