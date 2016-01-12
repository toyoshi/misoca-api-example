misoca-api-example
==================

# Setup

 - Misocaのアプリケーション登録をします。
   - https://app.misoca.jp/oauth2/applications
   - callback urlは、http://localhost:9393/callback
 - `.env`などを書き換えます
   - `APPLICATION_ID`、`APP_SECRET_KEY`を設定します。
 - `bundle install`とかします
 - `bundle exec shotgun app.rb`で起動

Misocaアカウントでの認証後、請求書一覧が表示されることを期待している。
