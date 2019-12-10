# tf-aws-log-kit
## Requirement
- Terraform >= 0.12.0

## Usage
- [delivery-func](delivery-func/README.md) You can send CWL log to the specified Kinesis FH stream
- [log-stream](log-stream/README.md) You can Kinesis FH record send to the specified ES and S3
- [slack-notification](slack-notification/README.md) You can notification send to the specified Slack channel

## example
### account case
- [single-account](example/single-account)
- [x-account](example/x-account)
