#!/bin/sh
set -eu

# DevContainerを起動する前に、このファイルを `chmod +x postCreateCommand.sh` しておく

# RubyMine 2025.3.1 の既知の不具合
# https://youtrack.jetbrains.com/projects/RUBY/issues/RUBY-34350/Cannot-find-Ruby-interpreter-in-the-Rails-devcontainer
# ただし、プライベートなgemのインストールがあるため、最後の `bin/setup --skip-server` は実行せず、コンテナ内で自分で実行する
sudo mkdir -p /.jbdevcontainer/config /.jbdevcontainer/data && sudo chmod -R 777 /.jbdevcontainer && ln -s /home/vscode/.config/mise /.jbdevcontainer/config/mise && ln -s /home/vscode/.local/share/mise /.jbdevcontainer/data/mise

npm install -g @openai/codex@latest