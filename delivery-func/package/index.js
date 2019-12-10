const aws  = require('aws-sdk');
const zlib = require('zlib');
const co = require('co');

const env = process.env.NODE_ENV;
const journalStream = process.env.JOURNAL_DELIVERY_STREAM_NAME;
const errorStream = process.env.ERROR_DELIVERY_STREAM_NAME;
const fhRoleArn = process.env.FH_ROLE_ARN;
const fhRegion = process.env.FH_REGION;

/**
 * Put records in Kinesis Firehose to be decorated and sent to Elasticsearch.
 *
 * @param fh  - AWS SDK Firehose object
 * @param records  - JSON records to be pushed to Firehose
 * @param streamName  - Firehose stream name
 * @return {Promise} Promise result for streaming Firehose
 */
function putRecords(fh, records, streamName) {
    const params = {
        DeliveryStreamName: streamName,
        Records: records
    };
    return fh.putRecordBatch(params).promise();
}

/**
 * Get session token for assume role
 *
 * @param sts  - AWS SDK sts object
 * @param roleArn  - role arn
 * @param roleSessionName  - role session name
 * @return {Promise} Promise result for assume role
 */
function assumeRole(sts, roleArn, roleSessionName) {
    const params = {
        RoleArn: roleArn,
        RoleSessionName: roleSessionName
    };
    return sts.assumeRole(params).promise();
}

/**
 * Creates records to be consumed in Firehose from VPC Flow Log events.
 *
 * @param {object} events - Log events
 * @return {Promise} streamLog Promise result
 */
function streamLog(events, fh) {
    let journalRecords = [];
    let errorRecords = [];

    const produceJournalPromise = [];
    const produceErrorPromise = [];

    events.forEach((event) => {
        if (event.messageType === 'CONTROL_MESSAGE') {
            console.log('Skipping control message');
            return;
        }

        const record = {
            Data: `${JSON.stringify(event.extractedFields)}\n`
        };
        journalRecords.push(record);
        if (event.extractedFields.level === 'ERROR') {
            errorRecords.push(record);
        }

        // catch at 500 records and push to firehose
        if (journalRecords.length > 499) {
            produceJournalPromise.push(putRecords(fh, journalRecords, journalStream));
            journalRecords = [];
        }
        if (errorRecords.length > 499) {
            produceErrorPromise.push(putRecords(fh, errorRecords, errorStream));
            errorRecords = [];
        }
    });

    // add Promise to Array
    if (journalRecords.length > 0) {
        produceJournalPromise.push(putRecords(fh, journalRecords, journalStream));
    }
    if (errorRecords.length > 0) {
        produceJournalPromise.push(putRecords(fh, errorRecords, errorStream));
    }

    return Promise.all(produceJournalPromise, produceErrorPromise);
}

/**
 * Main Lambda handler
 */
exports.handler = (event, context, callback) => {
    return co(function* () {
        try {
            // データの解凍
            const zippedData = Buffer.from(event.awslogs.data, 'base64');
            const data = zlib.gunzipSync(zippedData);
            const logData = JSON.parse(data.toString('utf8'));
            console.log(JSON.stringify(logData));

            // クロスアカウントでの通信を実現するためSTSでセッショントークン発行
            const sts = new aws.STS({apiVersion: '2011-06-15'});
            const res = yield assumeRole(sts, fhRoleArn, `${env}-delivery`);

            // Firehoseに送信
            const fh = new aws.Firehose({
                accessKeyId: res.Credentials.AccessKeyId,
                secretAccessKey: res.Credentials.SecretAccessKey,
                sessionToken: res.Credentials.SessionToken,
                region: fhRegion,
            });
            yield streamLog(logData.logEvents, fh);

            console.log('streaming success');
            callback(null, 'success');
        } catch (e) {
            console.log(`streaming fail. ${e}`);
            callback(e);
        }
    });
};
