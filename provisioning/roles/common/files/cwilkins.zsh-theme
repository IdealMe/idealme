# af-magic.zsh-theme
#
# Author: Andy Fleming
# URL: http://andyfleming.com/
# Repo: https://github.com/andyfleming/oh-my-zsh
# Direct Link: https://github.com/andyfleming/oh-my-zsh/blob/master/themes/af-magic.zsh-theme
#
# Created on:       June 19, 2012
# Last modified on: June 20, 2012



if [ $UID -eq 0 ]; then NCOLOR="red"; else NCOLOR="green"; fi
local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

# primary prompt
PROMPT='%{$reset_color%}
%{$fg_bold[cyan]%}%m \
$FG[032]%~ \
$fg_bold[blue][$fg[red]%D{%I:%M:%S}$fg_bold[blue]] \
$(rvm_prompt_info) \
$(git_prompt_info) \

$FG[105]%(!.#.»)%{$reset_color%} '
PROMPT2='%{$fg[red]%}\ %{$reset_color%}'
RPS1='${return_code}'


# color vars
eval my_gray='$FG[237]'
eval my_orange='$FG[214]'

# right prompt
# RPROMPT='$my_gray%n%{$reset_color%}%'

# git settings
ZSH_THEME_GIT_PROMPT_PREFIX="$FG[075](branch:"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="$my_orange*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="$FG[075])%{$reset_color%}"

# Color code depending on host
function color_code_host() {
  if [[ `hostname -s` == 'mini' || `hostname -s` == 'charlie' ]]; then
    echo "%{$bg[black]%}%{$fg[white]%}%m%{$reset_color%}"
  else
    echo "%{$bg[white]%}%{$fg[red]%}%m%{$reset_color%}"
  fi
}

function color_code_user() {
  if [[ `whoami` == 'root' ]]; then
    echo "%{$bg[red]%}%{$fg[yellow]%} %n %{$reset_color%}"
  else
    echo "%{$bg[black]%}%{$fg[white]%}%n%{$reset_color%}"
  fi
}
