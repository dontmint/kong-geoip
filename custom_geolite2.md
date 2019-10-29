# Download tools and database
```bash
git clone https://github.com/sherpya/geolite2legacy.git
cd geolite2legacy
wget https://geolite.maxmind.com/download/geoip/database/GeoLite2-Country-CSV.zip
unzip -o GeoLite2-Country-CSV.zip
wget https://geolite.maxmind.com/download/geoip/database/GeoLite2-ASN-CSV.zip
unzip -o GeoLite2-ASN-CSV.zip
```

# Custom CIDR by Country example

```bash
echo "21.0.0.0/8,1562822,1562822,,0,0
26.0.0.0/8,1562822,1562822,,0,0
100.64.0.0/10,1562822,1562822,,0,0
103.84.76.0/22,1562822,1562822,,0,0
" >> ./GeoLite2-Country-CSV_*/GeoLite2-Country-Blocks-IPv4.csv
```

# Custom CIDR by ASN example 

```bash
echo '43.239.148.0/22,18403,"The Corporation for Financing & Promoting Technology"
100.64.0.0/10,18403,"The Corporation for Financing & Promoting Technology"
21.0.0.0/8,18403,"The Corporation for Financing & Promoting Technology"
26.0.0.0/8,18403,"The Corporation for Financing & Promoting Technology"
203.99.248.0/22,7602,"Saigon Postel Corporation
' >> ./GeoLite2-ASN-CSV_*/GeoLite2-ASN-Blocks-IPv4.csv
```

# Compress zip

```bash
zip -rFS GeoLite2-Country-CSV-custom.zip GeoLite2-Country-CSV_20*/ 
zip -rFS GeoLite2-ASN-CSV-custom.zip GeoLite2-ASN-CSV_20*/
```

# Build file .dat
```bash
virtualenv venv
source venv/bin/activate
pip install -r requirements.txt
python geolite2legacy.py -i GeoLite2-Country-CSV-custom.zip -f geoname2fips.csv  -o GeoLite2-Country-custom.dat
python geolite2legacy.py -i GeoLite2-ASN-CSV-custom.zip -o GeoLite2-ASN-custom.dat
```
# Copy binary file to GeoIP location and replace current symlink

```bash
cp GeoLite2-Country-custom.dat /usr/share/GeoIP/
cp GeoLite2-ASN-custom.dat /usr/share/GeoIP/

unlink /usr/share/GeoIP/GeoIPASNum.dat 
unlink /usr/share/GeoIP/GeoIP.dat

ln -s /usr/share/GeoIP/GeoLite2-Country-custom.dat /usr/share/GeoIP/GeoIP.dat
ln -s /usr/share/GeoIP/GeoLite2-ASN-custom.dat /usr/share/GeoIP/GeoIPASNum.dat
```

