function 1_outputOfAllDomains() {
    # Prepare POST query
    postvars="user=$hestia_username&password=$hestia_password&returncode=$hestia_returncode&cmd=$hestia_command&arg1=$username&arg2=$format"

    # Send POST query via cURL
    answer=$(curl -k -s -X POST -d "$postvars" "https://$hestia_hostname:$hestia_port/api/")

    # Parse JSON output
    data=$(echo "$answer" | jq .)
    echo "$data"

    # Parse JSON output domains
    domain_list=$(echo "$answer" | jq -r 'keys[]')
    for domain in $domain_list; do
        echo "$domain"
    done

    # Parse JSON output "DOCUMENT_ROOT"
    document_roots=$(echo "$answer" | jq -r '.[].DOCUMENT_ROOT')
    echo "$document_roots"

}