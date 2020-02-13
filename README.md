# Deploy to ELB Action

This action executes a remote SSH command on all servers behind a given Amazon ELB (Elastic Load Balancer)

## Inputs

### `script`

**Required** The script to execute on the remote server. Default `"/home/ubuntu/deploy_ci.sh"`.

### `autoscaling_group_name`

**Required** The name of the autoscaling group to deploy to

### `ssh_key`

**Required** The private SSH key used to authenticate with the remote servers

## Example usage

```
name: CI

on:
  push:
    branches:
      - master

jobs:
  build:
    name: Build
    runs-on: ubuntu-latest
    steps:
      - name: Deploy to ELB
        uses: chriscohoat/deploy-to-elb-action@master
        with:
          script: /home/ubuntu/deploy_ci.sh
          autoscaling_group_name: ${{ secrets.AUTOSCALING_GROUP_NAME }}
          ssh_key: ${{ secrets.SSH_KEY }}
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          AWS_DEFAULT_REGION: ${{ secrets.AWS_DEFAULT_REGION }}
```