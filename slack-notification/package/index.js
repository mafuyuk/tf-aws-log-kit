const fetch = require('node-fetch');

/**
 * alarmSlackではSlackに通知を行います。
 *
 * @param  {string} url - Slackの通知先URL。
 * @param  {object} msg - Slackへの通知メッセージ。
 * @return {Promise<Object|Error>} - fetchの返り値をオブジェクトに変換した値。
 */
function alarmSlack(url, msg) {
    const body = JSON.stringify(msg);
    const options = {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'Content-Length': Buffer.byteLength(body),
        },
        body
    };
    return fetch(url, options);
}

/**
 * Main Lambda handler
 */
exports.handler = (event, context, callback) => {
    console.log('Warner catch error log');

    const message = JSON.parse(event.Records[0].Sns.Message).Records[0];
    console.log(JSON.stringify(message));

    const eventTime = message.eventTime;
    const bucketName = message.s3.bucket.name;
    const path = message.s3.object.key;

    const fields = [
        {
            title: 'EventTime',
            value: eventTime,
            short: false
        },
        {
            title: 'BucketName',
            value: bucketName,
            short: false
        },
        {
            title: 'Path',
            value: path,
            short: false
        }
    ];

    const msg = {
        username : "log-warner",
        icon_emoji : ":sos:",
        channel : process.env.CHANNEL,
        attachments : [{
            pretext: `エラーログが出力されました`,
            title: '詳細はこちら',
            title_link: `https://s3.console.aws.amazon.com/s3/object/${bucketName}/${path}`,
            color: 'danger',
            fields,
        }]
    };
    console.log(`sent slack. ${JSON.stringify(msg)}`);

    return alarmSlack(process.env.HOOK_URL, msg).then((res) => {
        console.log(`call slack. response status is ${res.status}`);
        if (res.status != 200) {
            throw new Error(`Fail alert Slack. ${JSON.stringify(res)}`);
        }
        console.log('success');
        callback(null, 'success');
    }).catch(e => {
        console.log(`error: ${e}`);
        callback(e);
    });
};
