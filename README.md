# embulk-trial

### 実行手順

#### 1. 認証ファイルを格納
input, outputへの認証ファイルを準備する
#### 2. イメージをビルド
`docker build . -t embulk --rm`

#### 3. コンテナ実行(実行時ジョブがCMDで発火する)
`docker run --rm embulk`

#### 4. ジョブ実行例
`docker run --rm embulk bash exe.sh config/config.yml.liquid`