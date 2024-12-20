# 概要
TeXプロジェクトをコンパイル時に自動でバックアップを取ってくれるコンテナです．

## How2Use
プロジェクトのセットアップには`setup.sh`を用いてください．
また，環境変数として`GITHUB_USER_NAME`が必要です．
#### 初回のみ
```sh
chmod +x setup.sh
echo 'GITHUB_USER_NAME=<your_user_name>' > .env
```
#### セットアップ
```sh
./setup.sh <project_name>
```

自動バックアップのためにはproject_nameと一致する名称のリポジトリがGitHub上に存在する必要があります．
このスクリプトでは，一つのプロジェクトに対して一つのリポジトリが存在することになります．
個人の用途に応じて`setup.sh`を改変して用いてください．

例えばTeXというリポジトリを用意しておき，そこにすべてのTeXソースを上げるようにするには以下のように修正し，プロジェクトルートでGitの初期化をすればよい．
```sh
END {
    my $timestamp = strftime("%Y-%m-%d %H:%M:%S", localtime);
    my \$commit_message = "${PROJECT_NAME}_\$timestamp";
    system("git config --global --add safe.directory /workdir/${PROJECT_NAME}");
    system("git branch -M main");
    system("cp ./out/${PROJECT_NAME}.pdf ./${PROJECT_NAME}.pdf");
    system("git add ${TEX_FILE} ${PROJECT_NAME}.pdf");
    system("git commit -m '\$commit_message'");
    system("git push origin main");
};
```

```sh
git init
git remote add origin git@github.com:${GITHUB_USER_NAME}/tex.git
```