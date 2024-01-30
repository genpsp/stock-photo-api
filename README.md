# StockPhoto API

画像共有サービス Web バックエンド (Go)

## 構築手順

### ローカル開発用 GCP キーの配置

プロジェクトルートに `stock-photo-test-gcp-key.json` を作成し、下記リンク先のシークレットの中身をコピペする

```
$ touch stock-photo-test-gcp-key.json
```

[LOCAL_GCP_KEY](https://console.cloud.google.com/security/secret-manager/secret/LOCAL_GCP_KEY/versions?hl=ja&project=stock-photo-test)

プロジェクトルートに `.env.local` を作成し、下記リンク先のシークレットの中身をコピペする

```
$ touch .env.local
```

[ENV_LOCAL](https://console.cloud.google.com/security/secret-manager/secret/ENV_LOCAL/versions?hl=ja&project=stock-photo-test)

### 初期化コマンド実行

docker が起動している状態で下記コマンドを実行する

```
$ make init
```

起動したら http://localhost:8000 で API にアクセス

## Cloud SQL への接続方法

google-cloud-sdk のインストール

```
$ curl -o cloud-sql-proxy https://storage.googleapis.com/cloud-sql-connectors/cloud-sql-proxy/v2.6.1/cloud-sql-proxy.darwin.arm64
$ chmod +x cloud-sql-proxy
```

cloud_sql_proxy で dev の CloudSQL に接続

```
$ ./cloud-sql-proxy --port 15432 stock-photo-test:asia-northeast1:stock-photo-database
```

成功すると `localhost:15432` で DB に接続できるようになる
