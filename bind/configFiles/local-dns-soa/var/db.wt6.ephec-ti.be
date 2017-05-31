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
ns1         IN      A       10.40.0.5

; Mail Server
@           IN      MX      10              mail
mail        IN	    A       10.40.0.20

; DKIM key mail
mail._domainkey     IN      TXT     ( "v=DKIM1; k=rsa; "
          "p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDJpHXqnDU3ACWEfTrSgykMm9QIxW9u+xjahUR78eanqMZBVoq3sMMpWOQdh9jlzGjohVZuYm/0vhrlbvOqC7eFoLQ2SMVZYI8qf49djCgcPfMjfl/57a16gdFpOpJbLV65hNCyZM1s8VaUe0MfmL9qL9ZuGjQ+1jcoqhCI0mo5cQIDAQAB" )

; SPF record
@           IN      SPF     "v=spf1 mx ~all"
@           IN      TXT     "v=spf1 mx ~all"

; Web Domain
@           IN      A       10.40.0.10
www         IN      CNAME   @
b2b         IN      A       10.40.0.10
intranet    IN      A       10.0.0.15

; Local Squid Proxy
squid       IN      A       10.0.0.10
