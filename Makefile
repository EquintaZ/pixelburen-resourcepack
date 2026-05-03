
package:
	rm -f Pixelburen.zip
	zip -r Pixelburen.zip assets/* pack.mcmeta pack.png

package-for-pixelburen: clean
	mkdir -p .pack-merge .pack-dnt .pack-sparkles
	wget https://cdn.modrinth.com/data/tpehi7ww/versions/HLvm1mCw/Dungeons%20and%20Taverns%20v5.1.0.zip -O .pack-dnt/DNT.zip
	cd .pack-dnt && unzip -o DNT.zip && rm -R data DNT.zip
	cp -R .pack-dnt/* .pack-merge/
	wget https://cdn.modrinth.com/data/HfNmMQ9E/versions/S8Oe9FyR/Sparkles_1.21.x_v1.1.6.zip -O .pack-sparkles/Sparkles.zip
	cd .pack-sparkles && unzip -o Sparkles.zip && rm Sparkles.zip
	cp -R .pack-sparkles/* .pack-merge/
	cp -R assets .pack-merge/
	cp pack.png .pack-merge/
	jq -s '{pack:{pack_format:(map(.pack.supported_formats // [])|add|min),supported_formats:[(map(.pack.supported_formats // [])|add|min),(map(.pack.supported_formats // [])|add|max)],min_format:(map(.pack.supported_formats // [])|add|min),max_format:(map(.pack.supported_formats // [])|add|max),description:.[0].pack.description},overlays:{entries:(map(.overlays.entries // [])|add)}}' \
		pack.mcmeta .pack-sparkles/pack.mcmeta > .pack-merge/pack.mcmeta
	cd .pack-merge && zip -r Pixelburen_$$(date +%Y-%m-%d).zip * && mv Pixelburen_$$(date +%Y-%m-%d).zip ../
	sha1sum Pixelburen_$$(date +%Y-%m-%d).zip

clean:
	rm -Rf .pack-merge .pack-dnt .pack-sparkles
