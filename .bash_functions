function __jenkins() {
	local cur tasks
	cur="${COMP_WORDS[COMP_CWORD]}"
	tasks="$(~/bin/jenkins --jobs)"
	COMPREPLY=( $(compgen -W "$tasks" $cur) )
}
complete -o default -F __jenkins jenkins c


# Exitcode function
## Echos exitcode if differs from 0 or 130
function ec {
	EC=$?
	if [[ "$EC" -ne 0 ]] && [[ "$EC" -ne 130 ]]; then
			echo -ne "\a$EC "
 	fi
}

# Remove diacritics - dosn't work correctly on osx
removedia() {
	iconv -f utf8 -t ASCII//TRANSLIT
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

ipwan(){
	if [ "$1" == "-n" ];then
		dig +short myip.opendns.com @resolver1.opendns.com|tr -d '\n'
	else
		dig +short myip.opendns.com @resolver1.opendns.com
	fi
}

proxy(){
	local proxyport=8080
	local proxyhost=127.0.0.1

	__proxy_unset(){
		unset http_proxy https_proxy no_proxy
		sed -i "" '/_proxy=/d' ~/.bash_local
	}
	__proxy_export(){
		(echo "export http_proxy=socks://$proxyhost:$proxyport/";
		echo "export https_proxy=socks://$proxyhost:$proxyport/";
		echo "export no_proxy=localhost,127.0.0.1,::1") >> ~/.bash_local
	}
	__proxy_start(){
		ssh home-http-proxy -o VisualHostKey=no -o PermitLocalCommand=no -D $proxyport -N -f -n && \
		networksetup -setsocksfirewallproxy Wi-Fi $proxyhost $proxyport && \
		echo -e '\e[1;32mProxy started\e[0m'
	}
	__proxy_stop(){
		pkill -f 'ssh home-http-proxy' && \
		networksetup -setsocksfirewallproxystate Wi-Fi off && \
		sed -i "" '/https\?_proxy/d' ~/.bash_local && \
		echo -e '\e[1;31mProxy stopped\e[0m'
	}
	__proxy_status(){
		networksetup -getsocksfirewallproxy Wi-Fi
		echo
		env | grep --colour=never "_proxy=" || true
	}
	__proxy_help(){
		echo "proxy start | stop | status | clean"
		echo
		echo "start:  start ssh dynamic tunnel, enable socks5 proxy, export variables"
		echo "stop:   stop ssh tunnel, disable socks5 proxy , unset variables"
		echo "status: print information about proxying"
		echo "clean:  unset variables"
	}

	if [ "$#" -eq 0 ]; then
		__proxy_help
	elif [ "$#" -eq 1 ]; then
		case "$1" in
			"status")
				__proxy_status
			;;"clean")
				__proxy_unset
			;;"start")		
				__proxy_start
				__proxy_export
			;;"stop")
				__proxy_stop
				__proxy_unset
			;;
		esac
	else
		__proxy_help
		echo -e "\a"
		return 1	 
	fi
}
		
			
