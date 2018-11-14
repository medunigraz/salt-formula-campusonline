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
