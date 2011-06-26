SCM_THEME_PROMPT_PREFIX=""
SCM_THEME_PROMPT_SUFFIX=""

SCM_THEME_PROMPT_DIRTY=" ${bold_red}✗${normal}"
SCM_THEME_PROMPT_CLEAN=" ${bold_green}✓${normal}"
SCM_GIT_CHAR="${bold_green}GIT${normal}"
SCM_SVN_CHAR="${bold_cyan}SVN${normal}"
SCM_HG_CHAR="${bold_red}HG${normal}"

case $TERM in
  xterm*)
  TITLEBAR="\[\033]0;\w\007\]"
  ;;
  *)
  TITLEBAR=""
  ;;
esac

PS3=">> "

is_vim_shell() {
  if [ ! -z "$VIMRUNTIME" ]
  then
    echo "[${cyan}vim shell${normal}]"
  fi
}

modern_scm_prompt() {
  CHAR=$(scm_char)
  if [ $CHAR = $SCM_NONE_CHAR ]
  then
    return
  else
    echo " [ $(rvm_version_prompt)/$(scm_prompt_info) ]"
  fi
}


function rvm_version_prompt {
  local gemset=$(echo $GEM_HOME | awk -F'@' '{print $2}')

  [ "$gemset" != "" ] && gemset="@$gemset"
  local version=$(echo $MY_RUBY_HOME | awk -F'-' '{print $2}')

  local patch=$(echo $MY_RUBY_HOME | awk -F'-' '{print $3}')
  [ "$patch" != "" ] && patch="-$patch"

  local full="$version$patch$gemset"

  [ "$full" != "" ] && echo "$full"
}


prompt() {
  if [ $? -ne 0 ]
  then
    # Yes, the indenting on these is weird, but it has to be like
    # this otherwise it won't display properly.
    PS1="${TITLEBAR}${bold_red}┌─${reset_color}[$(battery_charge)]$(modern_scm_prompt)[${cyan}\W${normal}]$(is_vim_shell)
${bold_red}└─▪${normal} "
  else
    PS1="${TITLEBAR}$(battery_charge)$(modern_scm_prompt) ${cyan}\W${normal} \u$ "
  fi
}

PS2="└─▪ "



PROMPT_COMMAND=prompt
