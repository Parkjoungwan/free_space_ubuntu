#!/usr/bin/env bash

# Avoid boring prefix in du/df/etc
cd "$HOME"

initial_used_space=$(du -sh "$HOME" | awk '{ print $1 }')

# Show current used space
initial_df=$(df -h . | grep -E "Filesystem|Size|Used|Avail|Capacity|[0-9]*\.*[0-9]*[MG] |$")
echo -e "Current space:\n$initial_df"
echo -e "\nHome folder:"

du -hd1 . 2>/dev/null | sort -h | grep "[0-9]*\.*[0-9]*M\t\|[0-9]*\.*[0-9]*G\t\|$"
echo ""

# 사용자 정의 함수 delete
delete() {
  local target="$1"
  read -p "Delete $target ? [y/N] " input
  echo ""
  if [ -n "$input" ] && [ "$input" = "y" ]; then
    rm -rf "$target"
  fi
}

# Delete heavy files/folders
delete "./Downloads/*"
delete "./.Trash/*"
delete "./.cache/*"
delete "./.local/share/Trash/*"  # Ubuntu에서는 .local/share/Trash에 있을 수 있음
delete "./.npm/_cacache/*"
delete "./.npm/_npx/*"
delete "./.npm/_cacache/*"
delete "./.yarn/*"
delete "./.config/Yarn/cache/*"
delete "./.config/Code/User/*"   # Visual Studio Code 설정 경로 수정
delete "./.config/Code/Cache/*"
delete "./.config/Code/CachedData/*"
delete "./.config/Code/Crashpad/completed/*"
delete "./.config/Code/User/workspaceStorage/*"
delete "./.config/Slack/Cache/*"
delete "./.config/Slack/Service Worker/CacheStorage/*"
delete "./.config/discord/Cache/*"
delete "./.config/discord/Code Cache/js/*"
delete "./.config/discord/Crashpad/completed/*"
delete "./.config/google-chrome/Default/Service\ Worker/CacheStorage/*"  # Google Chrome 경로 수정
delete "./.config/google-chrome/Crashpad/completed/*"
delete "./Library/Developer/CoreSimulator/*"

# Brew cleanup 부분은 Ubuntu에서 사용하지 않으므로 주석 처리
#read -n1 -p "Cleanup Homebrew? (brew cleanup) [y/N] " input
#echo ""
#if [ -n "$input" ] && [ "$input" = "y" ]; then
#  brew cleanup ;:
#fi

# Show before/after
echo -e "\nSpace before:\n$initial_df\n\nSpace after:"
df -h . | grep -E "Filesystem|Size|Used|Avail|Capacity|[0-9]*\.*[0-9]*[MG] |$"

# final_used_space 계산 방법 변경
final_used_space=$(du -sh "$HOME" | awk '{ print $1 }')
freed_space=$(du -sh "$HOME" | awk '{ printf("%.1f", '$initial_used_space' - '$final_used_space') }')
echo -e "\nFreed space: ${freed_space}G"
echo -e "Pro tip: use 'ncdu' (terminal, available with 'sudo apt-get install ncdu') to show a deep scan of your space."

