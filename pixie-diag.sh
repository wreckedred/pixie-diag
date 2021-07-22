#!/bin/bash

# Create a log file
exec > >(tee -a "$PWD/pixie-diag.log") 2>&1

echo ""
echo "*****************************************************"
echo "Checking agent status"
echo "*****************************************************"
echo ""

# Check for px
if ! [ -x "$(command -v px)" ]; then
  echo 'Error: px is not installed.' >&2
  else
  echo "Get agent status from Pixie"
  px run px/agent_status
  echo ""
  echo "Collect logs from Pixie"
  px collect-logs
fi

echo ""
echo "*****************************************************"
echo "Checking HELM releases"
echo "*****************************************************"
echo ""

# Check HELM releases
helm list -n newrelic

echo ""
echo "*****************************************************"
echo "Checking System Info"
echo "*****************************************************"
echo ""

# Check System Info
nodes=$(kubectl get nodes | awk '{print $1}' | tail -n +2)

for node_name in $nodes
  do
    # Get K8s version and Kernel from nodes
    echo ""
    echo "System Info from $node_name"
    kubectl describe node $node_name | grep -i 'Kernel Version\|OS Image\|Operating System\|Architecture\|Container Runtime Version\|Kubelet Version'
    done

echo ""
echo "*****************************************************"
echo "Check all Kubernetes resources in namespace"
echo "*****************************************************"
echo ""

# Get all api-resources in namespace
for i in $(kubectl api-resources --verbs=list --namespaced -o name | grep -v "events.events.k8s.io" | grep -v "events" | sort | uniq); 
do
echo ""
echo "Resource:" $i;
kubectl -n newrelic get --ignore-not-found ${i};
done

echo ""
echo "*****************************************************"
echo "Checking logs"
echo "*****************************************************"
echo ""

deployments=$(kubectl get deployments -n newrelic | awk '{print $1}' | tail -n +2)

for deployment_name in $deployments
  do
    # Get logs from deployed
    echo ""
    echo "Logs from $deployment_name"
    kubectl logs --tail=20 deployments/$deployment_name -n newrelic
    done

echo ""
echo "*****************************************************"
echo "Checking pod events"
echo "*****************************************************"
echo ""

pods=$(kubectl get pods -n newrelic | awk '{print $1}' | tail -n +2)

for pod_name in $pods
  do
    # Get events from pods in New Relic namespace
    echo ""
    echo "Events from pod name $pod_name"
    kubectl get events --all-namespaces  | grep -i $pod_name
    done

echo ""
echo "*****************************************************"
echo ""

echo "File created = pixie-diag.log"
echo "File created = pixie_logs_<date>.zip"

echo "End pixie-diag"
