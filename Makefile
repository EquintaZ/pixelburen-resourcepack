
package:
	rm -f Pixelburen.zip
	zip -r Pixelburen.zip assets/* pack.mcmeta pack.png

package-for-pixelburen:
	mkdir -p staging
	wget https://cdn.modrinth.com/data/HfNmMQ9E/versions/IW1cAtJC/Sparkles_1.21.x_v1.1.5.zip -O staging/Sparkles.zip
	cd staging && unzip -o Sparkles.zip
	cp -R assets staging/
	cp pack.* staging/
	rm staging/*.zip
	cd staging && zip -r Pixelburen.zip *
	mv staging/Pixelburen.zip .
	rm -R staging
