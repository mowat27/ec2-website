#!/usr/bin/env python3

import os
import sys

os.chdir(os.path.dirname(sys.argv[0]))

with open("yum.sh") as f:
    yum = f.read().strip()

with open("index.html") as f:
    index = f.read().strip()

with open("style.css") as f:
    style = f.read().strip()

script = f"""#!/bin/bash

{yum}

cat > index.html <<EOF
{index}
EOF

cat > style.css <<EOF
{style}
EOF
"""

print(script)
