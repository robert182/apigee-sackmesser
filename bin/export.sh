APIGEE_USER="robert.bryan.relucio@accenture.com"
APIGEE_PASS="P@ssw0rd182"
APIGEE_ORG="amer-mint-partner07"
APIGEE_ENV="test"
MANAGEMENT_SERVER_HTTPS_URL="https://api.enterprise.apigee.com"


./sackmesser export --apigeeapi -o "$APIGEE_ORG" -u "$APIGEE_USER" -p "$APIGEE_PASS" --opdk --baseuri "$MANAGEMENT_SERVER_HTTPS_URL"