# pixie-diag

A simple bash script to check the health of a Pixie-enabled cluster.

The script runs standard Kubernetes commands in the namespace that Pixie is installed in and creates an output file.

# Usage

From instance with access to cluster:
```
chmod +x pixie-diag.sh

usage: pixie-diag.sh <namespace>

./pixie-diag.sh newrelic
```

# Output

pixie-diag.sh outputs to terminal and creates two files:

- pixie_diag_<date>.log <-- stout to file

- pixie_logs_<date>.zip <-- logs to zip
