
package:
	rm -f Pixelburen.zip
	zip -r Pixelburen.zip assets/* pack.mcmeta pack.png

package-for-pixelburen: clean
	mkdir -p .pack-merge .pack-sparkles
	wget https://cdn.modrinth.com/data/HfNmMQ9E/versions/IW1cAtJC/Sparkles_1.21.x_v1.1.5.zip -O .pack-sparkles/Sparkles.zip
	cd .pack-sparkles && unzip -o Sparkles.zip && rm Sparkles.zip
	cp -R .pack-sparkles/* .pack-merge/
	cp -R assets .pack-merge/
	cp pack.png .pack-merge/
	jq -s '{pack:{pack_format:(map(.pack.supported_formats // [])|add|min),supported_formats:[(map(.pack.supported_formats // [])|add|min),(map(.pack.supported_formats // [])|add|max)],min_format:(map(.pack.supported_formats // [])|add|min),max_format:(map(.pack.supported_formats // [])|add|max),description:.[0].pack.description},overlays:{entries:(map(.overlays.entries // [])|add)}}' \
		pack.mcmeta .pack-sparkles/pack.mcmeta > .pack-merge/pack.mcmeta
	cd .pack-merge && zip -r Pixelburen_$$(date +%Y-%m-%d).zip *
	sha1sum .pack-merge/*.zip

clean:
	rm -Rf .pack-merge .pack-sparkles
