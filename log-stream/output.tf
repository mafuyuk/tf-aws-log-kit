output "stream_id" {
  value = "${aws_kinesis_firehose_delivery_stream.stream.id}"
}

output "stream_name" {
  value = "${aws_kinesis_firehose_delivery_stream.stream.name}"
}

output "stream_arn" {
  value = "${aws_kinesis_firehose_delivery_stream.stream.arn}"
}
