$TTL 3600 ; 1 hour
$ORIGIN wt6.ephec-ti.be.

; SOA
@           IN      SOA     ns1.wt6-ephec-ti.be     sysadmin.wt6.ephec-ti.be (
                                    2017041801  ; serial
                                    86400       ; refesh (1 day)
                                    3600        ; retry (1 hour)
                                    3600000     ; expire (41 days)
                                    3600        ; minimun (1 hour)
)

; Name Server
@           IN      NS      ns1
ns1         IN      A       151.80.119.135

; Mail Server
@	    IN      MX      10    mail
mail	    IN	    A       151.80.119.131
maxil._domainkey IN      TXT     ( "v=DKIM1; k=rsa; "
          "p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCvMZjLF7HuA/rKYQLKfBMpvkTK+OTHVbTrXxPQMz+P5pweK9nEz7pBnQQnMQmGQgtAbhx7Q28ghDHRIAzjqC5lDqebmC+uIsG2C3/0RxyOGSAlBl+ED/kKykHUF3JRhiu/USPd/cEU9pXfv7wukJf+uVOPp7eVdjg++KP5Lw5YnwIDAQAB" )  ; ----- DKIM key mail for wt6.ephec-ti.be

; Web domain
@           IN      A       151.80.119.135
www         IN      CNAME   @
b2b         IN      A       151.80.119.135
intranet    IN      A       151.80.119.135
