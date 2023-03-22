#!/bin/bash
set -ex
set +x
set +v

folder="step-upload-folder"

# ステップのリポジトリをクロンする
git clone https://github.com/nttr-mypocket/bitrise_step_google_drive_upload.git $folder

gem install google-apis-core
gem install googleauth
gem install google-apis-drive_v3

# rubyを実行する
ruby ./${folder}/ruby/upload.rb
