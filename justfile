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

_build host:
    @nix build .#nixosConfigurations.{{host}}.config.system.build.toplevel --no-link --print-out-paths

baseline:
    @just _build artemis > /tmp/artemis.before
    @just _build hermes  > /tmp/hermes.before
    @echo "baseline saved:"
    @echo "  artemis → $(cat /tmp/artemis.before)"
    @echo "  hermes  → $(cat /tmp/hermes.before)"

# baseline one host
baseline-host host:
    @just _build {{host}} > /tmp/{{host}}.before
    @echo "{{host}} baseline → $(cat /tmp/{{host}}.before)"

# diff one host against its saved baseline
diff-host host:
    @nvd diff $(cat /tmp/{{host}}.before) $(just _build {{host}})

# diff both hosts
diff:
    @just diff-host artemis
    @just diff-host hermes
