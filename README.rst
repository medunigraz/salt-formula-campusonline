====================
CAMPUSonline Formula
====================

Deploy CAMPUSonline related services.

Currently supported:

 - Secure Reverse Proxy


Sample Metadata
===============

CAMPUSonline reverse proxy:

.. code-block:: yaml

   campusonline:
      sites:
         mysite:
            hostname: online.university.com
            admin: webmaster@university.com
            proxy:
               path: MYPATH
               status:
                  - 10.200.14.0/23
                  - 10.200.50.12
               tls:
                  certificate: |
                     -----BEGIN CERTIFICATE-----
                     ...
                     -----END CERTIFICATE-----
                  chain: |
                     -----BEGIN CERTIFICATE-----
                     ...
                     -----END CERTIFICATE-----
                  key: |
                     -----BEGIN RSA PRIVATE KEY-----
                     ...
                     -----END RSA PRIVATE KEY-----
               services:
                  co_dp: http://co_dp.online.university.com:7002
                  co_ws: http://co_ws.online.university.com:7003
                  co_ee: http://co_ee.online.university.com:7001
                  reports: http://reports.online.university.com:7777
                  ohs: http://ohs.online.university.com:7777


Documentation and Bugs
======================

To learn how to install and update salt-formulas, consult the documentation
available online at:

    http://salt-formulas.readthedocs.io/

In the unfortunate event that bugs are discovered, they should be reported to
the appropriate issue tracker. Use GitHub issue tracker for specific salt
formula:

    https://github.com/medunigraz/salt-formula-campusonline/issues

For feature requests, bug reports or blueprints affecting entire ecosystem,
use Launchpad salt-formulas project:

    https://launchpad.net/salt-formulas

Developers wishing to work on the salt-formulas projects should always base
their work on master branch and submit pull request against specific formula.

You should also subscribe to mailing list (salt-formulas@freelists.org):

    https://www.freelists.org/list/salt-formulas

Any questions or feedback is always welcome so feel free to join our IRC
channel:

    #salt-formulas @ irc.freenode.net
