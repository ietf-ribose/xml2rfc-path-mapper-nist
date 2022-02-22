mkdir /tmp/bibxml-to-relaton
rsync -avuz xml2rfc.tools.ietf.org::xml2rfc.bibxml/bibxml-nist /tmp/bibxml-to-relaton
if [ ! -f /tmp/bibxml-to-relaton/main.zip ]; then wget https://github.com/ietf-ribose/relaton-data-nist/archive/refs/heads/main.zip -O /tmp/bibxml-to-relaton/main.zip; fi
if [ ! -d /tmp/bibxml-to-relaton/relaton-data-nist-main ]; then (cd /tmp/bibxml-to-relaton && unzip main.zip); fi
