Overview
========
**Warning:** this is under heavy development command line options WILL change! Always check back here for the latest.

**If you are running into errors, please check the troubleshooting section first**

Examples
========
Current Requirements -- Ubuntu 12.04 Desktop, User Logged In via the Unity Desktop, Open Terminal


Using `wget` to install the latest 

```
wget -O - https://raw.github.com/sans-dfir/sift-bootstrap/master/bootstrap.sh | sudo sh -s -- -i
```

Using `curl` to install the latest
```
curl -L https://raw.github.com/sans-dfir/sift-bootstrap/master/bootstrap.sh | sudo sh -s -- -i
```

Install, Configure, and Theme

```
wget -O - https://raw.github.com/sans-dfir/sift-bootstrap/master/bootstrap.sh | sudo sh -s -- -i -s -y
```

Configure Only

```
wget -O - https://raw.github.com/sans-dfir/sift-bootstrap/master/bootstrap.sh | sudo sh -s -- -c
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


Credit
======
Many parts of the bootstrap script were borrowed from https://github.com/saltstack/salt-bootstrap. Many thanks!