#!/bin/bash

# Timestamp
timestamp=$(date +"%Y%m%d%H%M%S")

# namespace variable
namespace=$1

# Create a log file
exec > >(tee -a "$PWD/pixie_diag_$timestamp.log") 2>&1

# Check for px
if ! [ -x "$(command -v px)" ]; then
  echo 'Error: px is not installed.' >&2
else
  echo "Get agent status from Pixie"
  px run px/agent_status
  # Skip if unable to get agent status
  if [ $? -eq 0 ]; then
    echo ""
    echo "Collect logs from Pixie"
    px collect-logs
  fi
fi

echo ""
echo "*****************************************************"
echo "Checking logs"
echo "*****************************************************"
echo ""

nr_deployments=$(kubectl get deployments -n $namespace | awk '{print $1}' | tail -n +2)
olm_deployments=$(kubectl get deployments -n olm | awk '{print $1}' | tail -n +2)
px_deployments=$(kubectl get deployments -n px-operator | awk '{print $1}' | tail -n +2)

#deployments=$(kubectl get deployments -n $namespace | awk '{print $1}' | tail -n +2)

for deployment_name in $nr_deployments $olm_deployments $px_deployments
  do
    # Get logs from deployments
    if [[ $deployment_name =~ ^newrelic-bundle-nri-kube-events.*$ ]];
    then
      echo -e "-------------------------------------------------\n"
      echo -e "Logs from $deployment_name container: kube-events\n"
      echo -e "-------------------------------------------------"
      kubectl logs --tail=50 deployments/$deployment_name -c kube-events -n $namespace
      echo -e "-------------------------------------------------\n"
      echo -e "Logs from $deployment_name container: infra-agent\n"
      echo -e "-------------------------------------------------"
      kubectl logs --tail=50 deployments/$deployment_name -c infra-agent -n $namespace
    else
      if [[ $deployment_name == "vizier-operator" ]]; then
        ns="px-operator"
      elif [[ $deployment_name == "catalog-operator" || $deployment_name == "olm-operator" ]]; then
        ns="olm"
      else
        ns=$namespace
      fi

      echo -e "-------------------------------------------------\n"
      echo -e "Logs from $deployment_name\n"
      echo -e "-------------------------------------------------"
      kubectl logs --tail=50 deployments/$deployment_name -n $ns
    fi
  done