$TTL 3600 ; 1 hour
$ORIGIN wt6.ephec-ti.be.

; SOA
@           IN      SOA     ns1.wt6-ephec-ti.be     sysadmin.wt6.ephec-ti.be (
                                    2017053103  ; serial
                                    86400       ; refesh (1 day)
                                    3600        ; retry (1 hour)
                                    3600000     ; expire (41 days)
                                    3600        ; minimun (1 hour)
)

; Name Server
@           IN      NS      ns1
ns1         IN      A       151.80.119.135

; Mail Server
@	    IN      MX      10              mail
mail    IN      A       151.80.119.135

; DKIM key mail
mail._domainkey	    IN      TXT     ( "v=DKIM1; k=rsa; "
	  "p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDKTpC0nl5mUNUh7VdxLdUd6lHkH5I2u0/HiVu1xqlMaj8QZhhN2RihxiXQuOw86/S/to1tmxXMlEwGbtmx96pZ/8HNkIF5J+BueZG9dp1uExKXLOnhw2Jp1ELlxtvfVL0HTLJ1+7eK2Q6IrTHGORF1bPNbdvFEWq6FwRGI7k1BfQIDAQAB" )

; SPF record
@           IN      SPF     "v=spf1 mx ~all"
@           IN      TXT     "v=spf1 mx ~all"

; Voip Server
voip        IN      A       151.80.119.135

; Web Domain
@           IN      A       151.80.119.135
www         IN      CNAME   @
b2b         IN      A       151.80.119.135
