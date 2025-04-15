FROM ubuntu:20.04

RUN apt-get update && apt-get install -y     curl git zsh sudo jq fzf ripgrep tmux     && rm -rf /var/lib/apt/lists/*

CMD [ "zsh" ]
