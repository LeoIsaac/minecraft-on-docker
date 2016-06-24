# minecraft-on-docker
## About
最近(6月25日現在)、マイクラの情報をウェブページにリアルタイムで流したりする遊びをしたりしているのですが、一々マイクラ鯖を構築し直したりするのが面倒くさいのです。
そこで最近使い始めたDockerでマイクラ鯖も構築できるように書いてみました。

## Useage
dockerとdocker-composeをインストールしている環境で、
```
git clone https://github.com/LeoIsaac/minecraft-on-docker.git
cd minecraft-on-docker
docker-compose up -d
```
を実行するだけです。
勿論、外部からアクセスを受け付けるので、ホスト側のポート開放が必須になります。ポート開放の方法については環境によって異なりますので、この場での説明は省きます。
