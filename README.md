# 手順

## ローカル開発用GCPキーの配置

プロジェクトルートに　```stock-photo-test-gcp-key.json```を作成し、下記のシークレットの中身をコピペする
https://console.cloud.google.com/security/secret-manager/secret/LOCAL_GCP_KEY/versions?hl=ja&project=stock-photo-test

プロジェクトルートの　```.env.local```に下記のシークレットの中身をコピペする
https://console.cloud.google.com/security/secret-manager/secret/ENV_LOCAL/versions?hl=ja&project=stock-photo-test

## 初期化コマンド実行

dockerが起動している状態で下記コマンドを実行する
```
make init
```
