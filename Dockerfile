# EmBulkの実行にはJavaが必要なため、Javaが含まれているベースイメージを使用します
FROM amazonlinux:2

# 作業ディレクトリを設定します
WORKDIR /usr/src/app

# install curl
RUN yum update && \
    yum install -y curl && \
    rm -rf /var/lib/apt/lists/*

RUN yum install -y java-1.8.0-openjdk

# install jruby
RUN curl --create-dirs -o "./jruby-complete-9.4.5.0.jar" -L "https://repo1.maven.org/maven2/org/jruby/jruby-complete/9.4.5.0/jruby-complete-9.4.5.0.jar"
RUN chmod +x ./jruby-complete-9.4.5.0.jar

# Embulkをダウンロードして実行可能にする
RUN curl --create-dirs -o ./embulk/bin/embulk -L "https://dl.embulk.org/embulk-0.11.4.jar" && \
    chmod +x ./embulk/bin/embulk

# install Ruby gems
COPY ./embulk.properties /root/.embulk/embulk.properties
RUN ./embulk/bin/embulk gem install embulk -v 0.11.4 # Embulk と同じバージョンを指定
RUN ./embulk/bin/embulk gem install msgpack -v 1.7.2
# RUN ./embulk/bin/embulk gem install bundler # if you need Bundler
# RUN ./embulk/bin/embulk gem install liquid  # if you need Liquid

# Embulkのプラグインをインストール
# 以下の例ではMySQLのプラグインをインストールしています
RUN ./embulk/bin/embulk gem install embulk-output-bigquery
RUN ./embulk/bin/embulk gem install embulk-input-gcs
RUN ./embulk/bin/embulk gem install embulk-input-mysql

copy ./ .

CMD ["java", "-jar", "embulk/bin/embulk", "run", "config/csv_to_bq.yml"]
