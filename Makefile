clean:
	rm -r dist

run:
	npm run dev

gen_enc_key: 
	openssl rand -hex 64
