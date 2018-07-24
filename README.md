# Concourse Quick Config

The following script will automatically configure concourse servers in your network via BOSH.

### Prerequisites

* bosh
* git
* bbl

### Installing

* Git clone code to directory
* update environment variables in concourse-env file.
* start script



## Deployment

quickconfigforconcource.sh will not prompt on change of instance type. It will skip any user prompts and just deploy. Script will create a folder under your ~/workspace directory with output.

## Usage
```
Tosins-MacBook-Pro:concousedeployments tosinakinosho$ ./quickconfigforconcourse.sh | tee output.log
Cloning into 'bosh-bootloader'...
remote: Counting objects: 26734, done.
remote: Compressing objects: 100% (161/161), done.
remote: Total 26734 (delta 105), reused 138 (delta 70), pack-reused 26488
Receiving objects: 100% (26734/26734), 15.81 MiB | 6.12 MiB/s, done.
Resolving deltas: 100% (18592/18592), done.
step: generating terraform template
step: generating terraform variables
step: terraform init
step: terraform init
step: terraform apply

```

## Built With

* [bosh-cli](https://bosh.io/docs/cli-v2/) bosh-cli
* [bbl](https://github.com/cloudfoundry/bosh-bootloader/) - bosh-bootloader


## Authors

* **Tosin Akinosho** - *Initial work* - [Gitlab](https://gitlab.altoros.com/oluwatosin.akinosho)
