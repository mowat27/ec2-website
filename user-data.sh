#!/bin/bash

# shellcheck disable=SC2164 
# shellcheck disable=SC2148

yum update -y
yum install httpd -y
chkconfig httpd on
service httpd start
cd /var/www/html

cat > index.html <<EOF
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Poppins&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="style.css">
    <title>Simple Site | Home</title>
</head>

<body>
    <h1>Simple Site</h1>
    <h2>Configuration</h2>
    <div class="config">
        <table>
            <thead>
                <th>Attribute</th>
                <th>Value</th>
            </thead>
            <tbody>
                <tr>
                    <td>Name</td>
                    <td><pre>${name}</pre></td>
                </tr>
                <tr>
                    <td>Started</td>
                    <td><pre>$(date)</pre></td>
                </tr>
                <tr>
                    <td>Region</td>
                    <td><pre>${aws_region}</pre></td>
                </tr>
            </tbody>
        </table>
    </div>
</body>

</html>
EOF

cat > style.css <<EOF
body {
    font-family: "Poppins", sans-serif;
}

tbody tr:nth-child(odd) {
    background-color: #eee;
}

.config {
    margin: 0 5%;
}

table {
    width: 100%;
}
EOF

