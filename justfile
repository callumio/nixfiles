default: 
	just --list

alias r := rebuild
alias v := vim
alias u := update
alias c := cache
alias d := deploy

rebuild:
	sudo nixos-rebuild switch --flake .#

deploy MACHINE:
	nix run .#deploy-{{MACHINE}}

vim:
  nix flake lock --update-input nvf

update:
	nix flake update

cache:
	devour-flake . | cachix push callumio-public
