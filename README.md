# pixie-diag

A simple bash script to check the health of a Pixie enabled cluster. 

The script runs standard Kubernetes commands in the newrelic namespace and creates a file.

# Usage

From instance with access to cluster

chmod +x pixie-diag.sh

./pixie-diag.sh

# OutPut

pixie-diag.sh outputs to terminal and creates two files.

pixie-diag.log <-- stout to file
pixie_logs_<date>.zip <-- logs to zip
