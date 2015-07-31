mine_functions:
  public_ip:
    - mine_function: grains.get
    - "ec2:public_ipv4"
  private_ip:
    - mine_function: grains.get
    - "ec2:local_ipv4"
