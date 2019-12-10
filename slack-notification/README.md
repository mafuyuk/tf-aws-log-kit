# tf-aws-log-kit//chat-notification
Slackに通知を送るLambdaを作成する
トリガーとしてSNSを登録してあるため、SNSをキックすることで利用できる

## Usage

```hcl
module "create_info_log_stream" {
  source         = "git::https://github.com/mafuyuk/tf-aws-log-kit//slack-notification?ref=master"
  s3_bucket      = "${var.s3_bucket}"
  slack_hook_url = "${var.slack_hook_url}"
  slack_channel  = "${var.slack_channel}"
}
```

## Variables
|  Name            |  Default  |  Description             | Required |
|:-----------------|:---------:|:-------------------------|:--------:|
| `s3_bucket`      | ``        | ログを格納するS3のバケット名 | Yes      |
| `slack_hook_url` | ``        | 通知を送るSlackのフックURL  | Yes      |
| `slack_channel`  | ``        | 通知を送るSlackのチャンネル | Yes      |

## Outputs
| Name          | Description    |
|:--------------|:---------------|
| `topic_id`    | トピックのID   　|
| `topic_arn`   | トピックのARN　  |
| `lambda_id`   | Lambda関数のID  |
| `lambda__arn` | Lambda関数のARN |
