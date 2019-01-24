###################################################################################
###
### ATTENTION: THIS FILE IS MANAGED BY PUPPET
###
### ANY CHANGE WILL BE REVERTED AUTOMATICALLY ON NEXT PUPPET RUN
###
### If you want to run your own dotfiles, specify another configuration directory
### source for hosting_basesetup::usermanagement::user => dotfile_sourcedir


unset LC_MESSAGES
unset LC_COLLATE
unset LC_CTYPE
export LANG=en_US.UTF-8

export HISTCONTROL=ignorespace

alias DATE='date "+%Y-%m-%d_%H-%M-%S"';
alias puppetrun="puppet agent --test";

alias pstime="ps -eo pid,etime,cmd";
alias psrss="ps -eo rss,pid,user,command --sort -size|awk '{ hr=\$1/1024 ; sum=hr+sum; print \$0 }END{print \"Total RSS: \" sum \" MB\"}'"

type -p less >/dev/null 2>&1 && export PAGER=less

lspath(){
  CURR="`/usr/*bin/nslookup $(uname -n) 2>/dev/null|awk '/^Name:.*'$(uname -n)'/{print $2;exit(0)}'`"
  if [ "$CURR" == "" ];then
    CURR="$(echo $SSH_CONNECTION|cut -d " " -f3)"
  fi
  if ( echo $1|egrep "^/" >/dev/null 2>&1); then
    echo -e "\n '${LOGNAME}@${CURR}:$1\n"
  else
    echo -e "\n '${LOGNAME}@${CURR}:${PWD}/$1\n"
  fi
}

if (type vim >/dev/null 2>&1);then alias vi="vim -c 'set bg=dark' -c 'syntax enable'"; fi
export EDITOR=vi

alias ls="ls --color";
alias l="ls -la";
alias ll="ls -l" ;
alias lf="ls -Fa";
alias sl="ls";
alias lt="ls -latr";
#alias mysql="mysql --pager='less -niSFX'";

export MYSQL_PS1="mysql://\u@\h:/\d - \R:\m:\s > ";

export LS_COLORS='no=00:fi=00:di=06;36:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.svgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01+;31:*.lzma=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35+:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mk+v=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.+aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:';

case $TERM in
    xterm*|linux)
       export PS1='$(EXC=$?;if [ $EXC != 0 ] ;then echo \[\e[31m\]ERR "$EXC : " ; fi)\[\e]0;\w\a\]\[\e[32m\]\u@\H(\D{%Y-%m-%d} \t) \[\e[31m\][PUPPET]\[\e[0m\] \[\e[33m\]\w\[\e[0m\] \n\$ \[\e]2;\H \w\a\]'
    ;;
esac

alias grep="grep --color=auto"

if [ -f "$HOME/.bashrc.custom" ];then
   source $HOME/.bashrc.custom
fi


# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

###
### ATTENTION: THIS FILE IS MANAGED BY PUPPET
###
### ANY CHANGE WILL BE REVERTED AUTOMATICALLY ON NEXT PUPPET RUN
###################################################################################
