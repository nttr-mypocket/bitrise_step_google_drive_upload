#!/bin/bash
set -ex
set +x
set +v

echo "Start Google Drive Upload"

echo "Print Enviroments"

echo "  lint_xml: $lint_xml"
echo "  lint_html: $lint_html"
echo "  lint_xml_output_file_name: $lint_xml_output_file_name"
echo "  lint_html_output_file_name: $lint_html_output_file_name"
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
git clone -b $step_branch $step_repository_url $scripts_dir
echo "Prepared Scripts file."

gem install google-apis-core
gem install googleauth
gem install google-apis-drive_v3

# rubyを実行する
ruby ./${scripts_dir}/ruby/upload.rb

# 環境変数を設定する
envman add --key GOOGLE_DRIVE_OUTPUT_URL --value ${drive_directory_url}

echo "Complete Google Drive Upload"
