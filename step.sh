#!/bin/bash

# Copyright © 2023 NTT Resonant Technology Inc. All Rights Reserved.

set -ex
set +x
set +v

echo "Start Google Drive Upload"

echo "Print Enviroments"

echo "  lint_file: $lint_file"
echo "  lint_output: $lint_output"
echo "  output_content_type: $output_content_type"
echo "  service_account_private_key: ******************"
echo "  service_account_id: $service_account_id"
echo "  drive_directory_id: $drive_directory_id"
echo "  drive_base_directory_url: $drive_base_directory_url"
echo "  step_repository_url: $step_repository_url"
echo "  step_upload_dir_branch: $step_upload_dir_branch"
echo "  step_branch: $step_branch"

echo "Generate Enviroments"
scripts_dir=$step_upload_dir_branch
drive_directory_url=${drive_base_directory_url}/${drive_directory_id}
echo "  scripts_dir: $scripts_dir"
echo "  drive_directory_url: $drive_directory_url"

# ステップのリポジトリをクローンする
echo "Prepare Scripts file, with Git Clone. Dir: $scripts_dir"
if [ -d "$scripts_dir" ]; then
  echo "Directory '$scripts_dir' already exists."
else
  echo "Cloning branch '$step_branch' from repository '$step_repository_url' to directory '$scripts_dir'..."
  git clone -b $step_branch $step_repository_url $scripts_dir
fi
echo "Prepared Scripts file."

gem install google-apis-core
gem install googleauth
gem install google-apis-drive_v3

# rubyを実行する
ruby ./${scripts_dir}/ruby/upload.rb

# 環境変数を設定する
envman add --key GOOGLE_DRIVE_OUTPUT_URL --value ${drive_directory_url}

echo "Complete Google Drive Upload"
