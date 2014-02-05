Overview
========


Examples
========
Current Requirements -- Ubuntu 12.04 Desktop, User Logged In via the Unity Desktop, Open Terminal

Install Only

```
wget -O - https://raw.github.com/sans-dfir/sift-bootstrap/master/bootstrap.sh | sudo sh -s -- -i -y
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

Credit
======
Many parts of the bootstrap script were borrowed from https://github.com/saltstack/salt-bootstrap. Many thanks!