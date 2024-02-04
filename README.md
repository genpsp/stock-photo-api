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
