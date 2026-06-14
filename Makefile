
package:
	rm -f Pixelburen.zip
	zip -r Pixelburen.zip assets/* pack.mcmeta pack.png

package-for-pixelburen: clean download-and-extract-dependent-packs package-with-dependent-packs

download-and-extract-dependent-packs:
	mkdir -p .pack-dnt .pack-backpack .pack-sparkles
	wget "https://cdn.modrinth.com/data/tpehi7ww/versions/HLvm1mCw/Dungeons%20and%20Taverns%20v5.1.0.zip" -O .pack-dnt/DNT.zip
	cd .pack-dnt && unzip -o DNT.zip && rm -R data DNT.zip
	wget "https://www.dropbox.com/scl/fi/rtx4hkfaxh3fzl2meg7ju/BackpackPlus_resourcepack_1_19_x-beyond.zip?rlkey=jp3jxtn4qdgzyq7yqqk1bg98p&st=tooq0mtd&dl=1" -O .pack-backpack/BackpackPlus.zip
	cd .pack-backpack && unzip -o BackpackPlus.zip && rm BackpackPlus.zip
	wget "https://cdn.modrinth.com/data/HfNmMQ9E/versions/S8Oe9FyR/Sparkles_1.21.x_v1.1.6.zip" -O .pack-sparkles/Sparkles.zip
	cd .pack-sparkles && unzip -o Sparkles.zip && rm Sparkles.zip

package-with-dependent-packs: clean-merge
	mkdir -p .pack-merge
	cp -R .pack-dnt/* .pack-merge/
	cp -R .pack-backpack/* .pack-merge/
	cp -R .pack-sparkles/* .pack-merge/
	cp -R assets .pack-merge/
	cp pack.png .pack-merge/
	jq -s '{pack:{pack_format:(map(.pack.supported_formats // [])|add|min),supported_formats:[(map(.pack.supported_formats // [])|add|min),(map(.pack.supported_formats // [])|add|max)],min_format:(map(.pack.supported_formats // [])|add|min),max_format:(map(.pack.supported_formats // [])|add|max),description:.[0].pack.description},overlays:{entries:(map(.overlays.entries // [])|add)}}' \
		pack.mcmeta .pack-sparkles/pack.mcmeta > .pack-merge/pack.mcmeta
	cd .pack-merge && zip -r Pixelburen_$$(date +%Y-%m-%d).zip * && mv Pixelburen_$$(date +%Y-%m-%d).zip ../
	sha1sum Pixelburen_$$(date +%Y-%m-%d).zip

clean: clean-merge
	rm -Rf .pack-dnt .pack-backpack .pack-sparkles

clean-merge:
	rm -Rf .pack-merge
