if status is-interactive
	export GPG_TTY=$(tty)
    # Commands to run in interactive sessions can go here
end

if uwsm check may-start && uwsm select
    exec uwsm start default
end
