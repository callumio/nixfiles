#!/bin/env bash

pick_session() {
	selected=$(ghq list -p | fzf || exit 0)

	if [[ -z $selected ]]; then
		exit 0
	fi

	selected_name=$(basename "$selected" | tr . _)
	tmux_running=$(pgrep tmux)

	if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
		tmux new-session -s "$selected_name" -c "$selected"
		exit 0
	fi

	if ! tmux has-session -t="$selected_name" 2>/dev/null; then
		tmux new-session -ds "$selected_name" -c "$selected"
	fi

	tmux switch-client -t "$selected_name"
}

switch_session() {
	selected=$(tmux list-sessions -F "#{session_name}" | fzf || exit 0)

	if [[ -z $selected ]]; then
		exit 0
	fi

	tmux switch-client -t "$selected"
}

selections=()
while getopts "sp" opt; do
	case ${opt} in
	p) selections+=("pick") ;;
	s) selections+=("switch") ;;
	\?)
		echo "Invalid usage"
		exit
		;;
	esac
done 2>/dev/null

case ${#selections[@]} in
1) selection=${selections[0]} ;;
*)
	echo "Please make exactly one selection (-p or -s)" >&2
	exit 1
	;;
esac
shift $((OPTIND - 1))

case $selection in
"pick") pick_session ;;
"switch") switch_session ;;
esac
