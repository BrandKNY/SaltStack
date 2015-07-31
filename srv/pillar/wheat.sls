wheat:
  checksum: "md5=edc452b2854e78d12e2b526f963272ca"
  port: 8081
  domain: staging.myapp.com
  apipath: /wheat/
  workers:
    wunderground: [WUNDERGROUND ID]
    aws:
      region: us-east-1
      credentials:
        key: [IAM USER ACCESS KEY ID HERE]
        secretKey: [IAM USER ACCESS KEY CODE HERE]
