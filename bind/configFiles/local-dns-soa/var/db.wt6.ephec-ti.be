$TTL 3600 ; 1 hour
$ORIGIN wt6.ephec-ti.be.

; SOA
@           IN      SOA     ns1.wt6-ephec-ti.be     sysadmin.wt6.ephec-ti.be (
                                    2017052602  ; serial
                                    86400       ; refesh (1 day)
                                    3600        ; retry (1 hour)
                                    3600000     ; expire (41 days)
                                    3600        ; minimun (1 hour)
)

; Name Server
@           IN      NS      ns1
ns1         IN      A       10.40.0.5

; Web domain
@           IN      A       10.40.0.10
www         IN      CNAME   @
b2b         IN      A       10.40.0.10
intranet    IN      A       10.0.0.15

; Local Squid Proxy
squid       IN      A       10.0.0.10
