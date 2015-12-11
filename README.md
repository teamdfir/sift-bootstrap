If you have bugs or issues to track please use https://github.com/sans-dfir/sift/issues

**You must use bash not sh to run this script**

Overview
========
Welcome to the SANS Investigative Forensic Toolkit Installation Bootstrap Script. 

**Requirements:** Ubuntu 14.04 LTS Dekstop, Logged In User (as in GUI, not terminal (F1, F2)), Package Manager Not Running

**If you are running into errors, please check the troubleshooting section first**

**Parts of this script were borrowed from SaltStack's bootstrap script! Thanks!**

**Note:** 12.04 is no longer supported going forward.

Documentation
=============
Check out the latest documentation for SIFT at http://sift.readthedocs.org/en/latest


Examples
========
Using `wget` to install the latest 

```
wget --quiet -O - https://raw.github.com/sans-dfir/sift-bootstrap/master/bootstrap.sh | sudo bash -s -- -i
```

Using `curl` to install the latest
```
curl --silent -L https://raw.github.com/sans-dfir/sift-bootstrap/master/bootstrap.sh | sudo bash -s -- -i
```

Install, Configure, and Theme

```
wget --quiet -O - https://raw.github.com/sans-dfir/sift-bootstrap/master/bootstrap.sh | sudo bash -s -- -i -s -y
```

Configure Only

```
wget --quiet -O - https://raw.github.com/sans-dfir/sift-bootstrap/master/bootstrap.sh | sudo bash -s -- -c
```

Options
=======
* i - install
* y - yes to all (only required when using -s)
* s - apply theme (aka the SIFT skin)
* c - configure only (create directories, no theme, no install)

Troubleshooting
===============
If you are receiving errors, please look at the Issues queue and see if there is already an issue open.

If you have a unique issue, please create a new Issue, and include the output of your terminal from the bootstrap script down until the error.

If you are getting apt-get errors, please make sure that the GUI package manager is not running.

Credit
======
Many parts of the bootstrap script were borrowed from https://github.com/saltstack/salt-bootstrap. Many thanks!
