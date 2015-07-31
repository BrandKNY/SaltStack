logserver:
  port: 514
  hostname: log-server.staging-internal
  s3:
    key: [IAM USER ACCESS KEY ID HERE]
    secretKey: [IAM USER ACCESS KEY CODE HERE]
    region: us-east-1
    bucket: testnet/logs
    filesize: 104857600