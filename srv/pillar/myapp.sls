myapp:
  port: 8080
  domain: staging.myapp.com
  database: myapp
  apipath: /
  url: http://staging.myapp.com
  aws:
    region: us-east-1
    credentials:
      key: [IAM USER ACCESS KEY ID HERE]
      secretKey:[IAM USER ACCESS KEY CODE HERE]
    swf:
      domain: staging.myapp.com
    s3:
      bucket: staging-myapp
    sqs:
      prefix: staging-myapp-com-
    sns:
      topic: staging-myapp-com
  email:
    from:
      address: notification@myapp.com
      name: MyApp Notification
  git:
    name: git@bitbucket.org:webcbg/myapp.git
    rev: 7b92023
    worker-rev: 7b92023
    key: |
      -----BEGIN RSA PRIVATE KEY-----
     [ CAT && COPY YOUR  GIT DEPLOYMENT KEY INTO HERE (PULL ONLY) ]
      -----END RSA PRIVATE KEY-----
