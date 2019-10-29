git clone https://github.com/sherpya/geolite2legacy.git
cd geolite2legacy

wget https://geolite.maxmind.com/download/geoip/database/GeoLite2-Country-CSV.zip
unzip -o GeoLite2-Country-CSV.zip
wget https://geolite.maxmind.com/download/geoip/database/GeoLite2-ASN-CSV.zip
unzip -o GeoLite2-ASN-CSV.zip

# Custom CIDR by Country
echo "21.0.0.0/8,1562822,1562822,,0,0
26.0.0.0/8,1562822,1562822,,0,0
100.64.0.0/10,1562822,1562822,,0,0
103.84.76.0/22,1562822,1562822,,0,0
" >> ./GeoLite2-Country-CSV_*/GeoLite2-Country-Blocks-IPv4.csv

# Custom CIDR by ASN
echo '43.239.148.0/22,18403,"The Corporation for Financing & Promoting Technology"
100.64.0.0/10,18403,"The Corporation for Financing & Promoting Technology"
21.0.0.0/8,18403,"The Corporation for Financing & Promoting Technology"
26.0.0.0/8,18403,"The Corporation for Financing & Promoting Technology"
203.99.248.0/22,7602,"Saigon Postel Corporation
' >> ./GeoLite2-ASN-CSV_*/GeoLite2-ASN-Blocks-IPv4.csv


# Compress zip
zip -rFS GeoLite2-Country-CSV-custom.zip GeoLite2-Country-CSV_20*/ 
zip -rFS GeoLite2-ASN-CSV-custom.zip GeoLite2-ASN-CSV_20*/

# Build file .dat
#virtualenv venv
#source venv/bin/activate
python geolite2legacy.py -i GeoLite2-Country-CSV-custom.zip -f geoname2fips.csv  -o GeoLite2-Country-custom.dat
python geolite2legacy.py -i GeoLite2-ASN-CSV-custom.zip -o GeoLite2-ASN-custom.dat

cp GeoLite2-Country-custom.dat /usr/share/GeoIP/
cp GeoLite2-ASN-custom.dat /usr/share/GeoIP/

unlink /usr/share/GeoIP/GeoIPASNum.dat 
unlink /usr/share/GeoIP/GeoIP.dat

ln -s /usr/share/GeoIP/GeoLite2-Country-custom.dat /usr/share/GeoIP/GeoIP.dat
ln -s /usr/share/GeoIP/GeoLite2-ASN-custom.dat /usr/share/GeoIP/GeoIPASNum.dat
