function _jenkins() {
    local cur tasks
    cur="${COMP_WORDS[COMP_CWORD]}"
    tasks="$(~/bin/jenkins --jobs)"
    COMPREPLY=( $(compgen -W "$tasks" $cur) )
}
complete -o default -F _jenkins jenkins c


# Exitcode function
## Echos exitcode if differs from 0 or 130
function ec {
	EC=$?
	if [[ "$EC" -ne 0 ]] && [[ "$EC" -ne 130 ]]; then
			echo -ne "\a$EC "
 	fi
}

# Remove diacritics
removedia() {
	iconv -t ASCII//TRANSLIT
}

# ps grep
function psg() {
	ps auxww | grep -i $* | grep -v grep
}

# Password generator
genpasswd() {
	local l=$1
	[ "$l" == "" ] && l=20
	LC_CTYPE=C tr -dc A-Za-z0-9_ < /dev/urandom | head -c ${l} | xargs
}

# Get MY passwords
mygetpass() {
	GPG_ENCRYPTED_FILE="$HOME/Documents/.pass/my.gpg"
	GPG_USER_ID='Jakub Jindra'
	gpg --no-batch -d -r '${GPG_USER_ID}' ${GPG_ENCRYPTED_FILE} 2> /dev/null | grep -i $1 | column -t
}

# Get SBKS passwords
getpass() {
	GPG_ENCRYPTED_FILE="$HOME/socialbakers/passwords.gpg"
	GPG_USER_ID='Jakub Jindra'
	gpg --no-batch -d -r '${GPG_USER_ID}' ${GPG_ENCRYPTED_FILE} 2> /dev/null | grep -i $1 | column -t
}

refreshpass() {
	GPG_ENCRYPTED_FILE="$HOME/socialbakers/passwords.gpg"
	rm $GPG_ENCRYPTED_FILE
	ssh -q adm1.svc.nag.ccl 'sudo cat /root/.pass.new' | gpg --no-batch -e --recipient "Jakub Jindra" -o $GPG_ENCRYPTED_FILE
}
