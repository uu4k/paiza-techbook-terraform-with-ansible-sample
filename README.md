# ansibleをterraformに依存させる3つの方法 サンプルコード

## 動作確認環境

- macOS Mojave 10.14.6
- terraform 0.12.6
- ansible 2.8.0
- terraform-inventory 0.9
- jq 1.6

## 構成概要(master以外は異なる場合があります)

```
.
├── ec2.tf # ec2関連の設定
├── rds.tf # rds関連の設定
├── terraform.tf # terraformの共通設定
├── vpc.tf # vpc関連の設定
├── inventories # inventory関連のディレクトリ
│   └── development
│       ├── group_vars
│       │   └── all
│       │       └── vars.yml # 全体適用の変数設定
│       └── hosts # inventoryの対象サーバリスト
├── roles # playbookで利用するrole関連のディレクトリ
│   ├── httpd
│   │   └── tasks
│   │       └── main.yml
│   ├── php
│   │   └── tasks
│   │       └── main.yml
│   └── wordpress
│       └── tasks
│           └── main.yml
└── wordpress.yml # wordpress設定するためのplaybook
```

## 実行方法

```
$ git clone https://github.com/uu4k/paiza-techbook-terraform-with-ansible-sample
$ cd paiza-techbook-terraform-with-ansible-sample
$ terraform init
$ terraform apply
### 作成されたec2とpublic_ipとrdsのendpoint確認
### inventoryのhostsとgroup_varsに確認した内容を反映
$ ansible-playbook --private-key=/path/to/ec2user/key --inventory-file=inventories/development wordpress.yml
### 片付けはterraform destroyで
```