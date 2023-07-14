#!/bin/bash

# Copyright 2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# <http://www.apache.org/licenses/LICENSE-2.0>
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

echo "<h3>Virtual Hosts</h3>" >> "$report_html"

mkdir -p "$export_folder/$organization/config/resources/edge/env/$environment/virtualhost"

sackmesser list "organizations/$organization/environments/$environment/virtualhosts"| jq -r -c '.[]|.' | while read -r virtualhostname; do
        sackmesser list "organizations/$organization/environments/$environment/virtualhosts/$(urlencode "$virtualhostname")" > "$export_folder/$organization/config/resources/edge/env/$environment/virtualhost/$(urlencode "$virtualhostname")".json
    done

if ls "$export_folder/$organization/config/resources/edge/env/$environment/virtualhost"/*.json 1> /dev/null 2>&1; then
    jq -n '[inputs]' "$export_folder/$organization/config/resources/edge/env/$environment/virtualhost"/*.json > "$export_folder/$organization/config/resources/edge/env/$environment/virtualhosts".json
fi

echo "<div><table id=\"virtualhost-lint\" data-toggle=\"table\" class=\"table\">" >> "$report_html"
echo "<thead class=\"thead-dark\"><tr>" >> "$report_html"
echo "<th data-sortable=\"true\" data-field=\"id\">Name</th>" >> "$report_html"
echo "<th data-sortable=\"true\" data-field=\"aliases\">Host Aliases</th>" >> "$report_html"
echo "<th data-sortable=\"true\" data-field=\"port\">Port</th>" >> "$report_html"
echo "<th data-sortable=\"true\" data-field=\"freecert\">useBuiltInFreeTrialCert</th>" >> "$report_html"
echo "</tr></thead>" >> "$report_html"

echo "<tbody class=\"mdc-data-table__content\">" >> "$report_html"

if [ -f "$export_folder/$organization/config/resources/edge/env/$environment/virtualhosts".json ]; then
    jq -c '.[]' "$export_folder/$organization/config/resources/edge/env/$environment/virtualhosts".json | while read i; do 
        name=$(echo "$i" | jq -r '.name')
        hostAliases=$(echo "$i" | jq -r '.hostAliases[]')
        port=$(echo "$i" | jq -r '.port')
        useBuiltInFreeTrialCert=$(echo "$i" | jq -r '.useBuiltInFreeTrialCert')

        echo "<tr class=\"$highlightclass\">"  >> "$report_html"
        echo "<td>$name</td>"  >> "$report_html"
        echo "<td>$hostAliases</td>" >> "$report_html"
        echo "<td>$port</td>" >> "$report_html"
        echo "<td>$useBuiltInFreeTrialCert</td>" >> "$report_html"
        echo "</tr>"  >> "$report_html"
    done
fi

echo "</tbody></table></div>" >> "$report_html"