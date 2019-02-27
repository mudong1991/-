; BIND reverse data file for rtd4cdforward.io
;
; This task effects after several tries
;
$TTL	86400
@		IN		SOA		rtd4cdforward.io.	root.rtd4cdforward.io. (
				2						; Serial
				604800					; Refresh
				86400					; Retry
				2419200					; Expire
				86400 )					; Negative Cache TTL
;
@		IN	NS	ns.cdforward.org.		; use ns.cdforward.org as ns
@		IN	A	10.2.25.113				; local ip
www		IN	A	10.2.25.113				; provide www
*		IN	A	10.2.25.113				; provide subdomain
