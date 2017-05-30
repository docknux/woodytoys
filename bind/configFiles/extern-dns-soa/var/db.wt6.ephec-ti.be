$TTL 3600 ; 1 hour
$ORIGIN wt6.ephec-ti.be.

; SOA
@           IN      SOA     ns1.wt6-ephec-ti.be     sysadmin.wt6.ephec-ti.be (
                                    2017052901  ; serial
                                    86400       ; refesh (1 day)
                                    3600        ; retry (1 hour)
                                    3600000     ; expire (41 days)
                                    3600        ; minimun (1 hour)
)

; Name Server
@           IN      NS      ns1
ns1         IN      A       151.80.119.135

; Mail Server
@	        IN      MX      10              mail
mail	    IN	    A       151.80.119.135

; Web Domain
@           IN      A       151.80.119.135
www         IN      CNAME   @
b2b         IN      A       151.80.119.135
