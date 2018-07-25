#!/bin/bash
# This script will autotomaitcally create a concourse server with a custom root disk_size


source concourse-env
source boshdependencies.sh

if [[ ! -d ~/workspace ]]; then
    mkdir ~/workspace
fi

#check for debug mode
if [[ $DEBUG == "TRUE" ]]; then
	RUNDEBUG="--debug"
fi


CONCOURSEWORKSPACE=concourse_$(date +%Y%m%d_%H%M%S)
cd ~/workspace/
mkdir $CONCOURSEWORKSPACE && cd $CONCOURSEWORKSPACE

git clone https://github.com/cloudfoundry/bosh-bootloader.git
cd bosh-bootloader
bbl up --lb-type concourse $RUNDEBUG

export external_url="https://$(bbl lbs | awk -F':' '{print $2}' | tr -d ' ')"
echo "$external_url" || exit 1
eval "$(bbl print-env)"

bosh upload-stemcell https://bosh.io/d/stemcells/bosh-google-kvm-ubuntu-trusty-go_agent

cat > "update_config.yml" << EOF
- type: replace
  path: /vm_types/name=default/cloud_properties?
  value:
    machine_type: ${MACHINETYPE}
    root_disk_size_gb: ${ROOTDISKSIZE}
    root_disk_type: pd-ssd
EOF

## automatically update the colud config env to preset disk size
bosh cloud-config > cloud.yml || exit 1
bosh interpolate cloud.yml --ops-file update_config.yml > new_cloud_config.yml
bosh update-cloud-config new_cloud_config.yml -n


## GO to consourse bosh deployment path
git clone https://github.com/concourse/concourse-bosh-deployment.git
cd concourse-bosh-deployment/cluster

## start concourse deployment
bosh deploy -d concourse concourse.yml \
  -l ../versions.yml \
  --vars-store cluster-creds.yml \
  -o operations/no-auth.yml \
  -o operations/privileged-http.yml \
  -o operations/privileged-https.yml \
  -o operations/tls.yml \
  -o operations/tls-vars.yml \
  -o operations/web-network-extension.yml \
  --var network_name=default \
  --var external_url=$external_url \
  --var web_vm_type=default \
  --var db_vm_type=default \
  --var db_persistent_disk_type=10GB \
  --var worker_vm_type=default \
  --var deployment_name=concourse \
  --var web_network_name=private \
  --var web_network_vm_extension=lb -n

sleep 15s

bosh vms

echo "OUTPUT PATH:"
echo "cd ../../$(pwd)"
echo "You may need to export the following into your env"

echo 'eval "$(bbl print-env)"'
echo "Your Concourse URL: $external_url"
