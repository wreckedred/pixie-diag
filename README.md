# pixie-diag

A simple bash script to check the health of a Pixie-enabled cluster.

The script runs standard Kubernetes commands in the namespace that Pixie is installed in and creates an output file.

# Usage

```
pixie-diag.sh <namespace>
```

Run from instance with access to cluster. The namespace will typically be either `px` or `newrelic`, depending on your installation.
```
wget https://raw.githubusercontent.com/wreckedred/pixie-diag/main/pixie-diag.sh
chmod +x pixie-diag.sh
./pixie-diag.sh newrelic
```

# Output

`pixie-diag.sh` outputs to terminal and creates two files:

- pixie_diag_<date>.log <-- stdout to file

- pixie_logs_<date>.gzip <-- logs to gzip
