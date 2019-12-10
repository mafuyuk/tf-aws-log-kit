# tf-aws-log-kit//log-stream
ログの配信を行うKinesis Firehoseのストリームを作成します

## Usage

```hcl
module "create_info_log_stream" {
  source      = "git::https://github.com/mafuyuk/tf-aws-log-kit//log-stream?ref=master"
  account_id  = "${data.aws_caller_identity.test.account_id}"
  stream_name = "${terraform.env}-${var.app_name}-info"
  s3_bucket   = "${var.bucket}"
  s3_prefix   = "AWSLogs/${data.aws_caller_identity.test.account_id}/${var.app_name}/info/${terraform.env}/"
  es_region   = "${var.es_region}"
  es_domain   = "${var.es_domain}"
  es_index    = "${var.app_name}"
  es_type     = "info"
}
```

## Variables
|  Name         |  Default  |  Description                                                                                                        | Required |
|:--------------|:---------:|:--------------------------------------------------------------------------------------------------------------------|:--------:|
| `account_id`  | ``        | AWSのアカウントID                                                                                                     | Yes      |
| `stream_name` | ``        | ログの配信を行うストリーム名                                                                                            | Yes      |
| `s3_bucket`   | ``        | ログを格納するS3のバケット名                                                                                            | Yes      |
| `s3_prefix`   | ``        | ログを格納するS3のバケットのプレフィックス先                                                                              | Yes       |
| `es_region`   | ``        | ログを格納するESのリージョン                                                                                            | Yes       |
| `es_domain`   | ``        | ログを格納するESのドメイン名                                                                                            | Yes       |
| `es_index`    | ``        | ESにログを格納する際につけるインデックス名 (e.g. `test-app`を指定するとインデックスは`test-app-2017-09-15`という形式になります) | Yes      |                                                            | No       |
| `es_type`     | ``        | ESにログを格納する際につけるタイプ (e.g. `info`)                                                                         | Yes      |

## Outputs
| Name          | Description    |
|:--------------|:---------------|
| `stream_id`   | ストリームのID 　|
| `stream_arn`  | ストリームのARN　|
