# tf-aws-log-kit//delivery-func
ロググループのサブスクリプションフィルタをトリガとしたLambdaを作成する
そのLambdaはログのフィルターにマッチした形に整形し、指定のKinesis FHにデータを流し込む

## Usage

```hcl
module "create_delivery_func" {
  source = "git::https://github.com/mafuyuk/tf-aws-log-kit//delivery-func?ref=master"

  providers = {
    "aws.src" = "aws.myprov"
    "aws.dst" = "aws.logprov"
  }

  src_region                      = "us-east-1"
  dst_region                      = "us-east-1"
  lambda_function_name            = "dev-delivery"
  cwl_filter_pattern              = "[timestamp=*Z, request_id=\"*-*\", level, appname, msg]"
  cwl_log_group_name              = "/aws/lambda/my-app"
  fh_stream_journal_function_name = "${module.create_info_stream.stream_name}"
  fh_stream_journal_arn           = "${module.create_info_stream.stream_arn}"
  fh_stream_error_function_name   = "${module.create_error_stream.stream_name}"
  fh_stream_error_arn             = "${module.create_error_stream.stream_arn}"
}
```



## Variables
|  Name                             |  Default    |  Description                                       | Required |
|:----------------------------------|:-----------:|:---------------------------------------------------|:--------:|
| `providers`                       | ``          | プロバイダ `aws.src`と`aws.dst`を指定するひつようがある | Yes      |
| `src_region`                      | `us-east-1` | ログの送信元のリージョン                              | No       |
| `dst_region`                      | `us-east-1` | ログの送信先のリージョン                              | No       |
| `lambda_function_name`            | ``          | lambda関数名                                       | Yes       |
| `cwl_filter_pattern`              | ``          | フィルターパターン                                   | Yes      |
| `cwl_log_group_name`              | ``          | ログを収集するロググループの名前                       | Yes      |
| `fh_stream_journal_function_name` | ``          | journalログのストリーム名                            | Yes      |
| `fh_stream_journal_arn`           | ``          | journalログのストリームARN                           | Yes      |
| `fh_stream_error_function_name`   | ``          | errorログのストリーム名                              | Yes      |
| `fh_stream_error_arn`             | ``          | errorログのストリームARN                             | Yes      |


## Outputs
| Name          | Description    |
|:--------------|:---------------|
| `lambda_id`   | Lambda関数のID  |
| `lambda_arn` | Lambda関数のARN |

## FAQ
#### クロスアカウントやマルチリージョンに対応するためには?
`providers`や `src_account_id`,`src_region`,`dst_region`を違うAWSプロバイダやリージョンにする
