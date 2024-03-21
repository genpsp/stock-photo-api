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

(docker 未インストールの場合は [Docker Desktop](https://www.docker.com/ja-jp/products/docker-desktop/) からインストール)

```
$ make init
```

起動したら http://localhost:8000 で API にアクセス

### make init が失敗する場合
`Docker Desktop -> Settings -> General`
で `osxfs (Legacy)` を選択し `Use Rosetta for x86_64/amd64 emulation on Apple Silicon` にチェックを入れてApply&restartする

## Cloud SQL への接続方法

google-cloud-sdk のインストール

```
$ curl -o cloud-sql-proxy https://storage.googleapis.com/cloud-sql-connectors/cloud-sql-proxy/v2.6.1/cloud-sql-proxy.darwin.arm64
$ chmod +x cloud-sql-proxy
```

cloud_sql_proxy で dev の CloudSQL に接続

```
$ ./cloud-sql-proxy --address 127.0.0.1 --port 13306 stock-photo-test:asia-northeast1:stock-photo-database
```

成功すると `localhost:13306` で DB に接続できるようになる

### Open API 生成

#### Open API ドキュメント生成

npm ライブラリをインストール

```
$ npm install -g swagger2openapi
```

下記コマンドを実行

```
$ make swagger-gen
```

#### Open API コード生成

下記コマンドを実行（型定義のみ生成）

```
$ make openapi-gen
```
