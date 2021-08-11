# pixie-diag

A simple bash script to check the health of a Pixie enabled cluster. 

The script runs standard Kubernetes commands in the namespace that Pixie is installed and creates a file.

# Usage

From instance with access to cluster

chmod +x pixie-diag.sh

./pixie-diag.sh mynamespace

# Output

pixie-diag.sh outputs to terminal and creates two files.

pixie-diag.log <-- stout to file

pixie_logs_<date>.zip <-- logs to zip
