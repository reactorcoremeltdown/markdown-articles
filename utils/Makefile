cv: ../static/cv-en.md
		mkdir ../ext-build || true && \
		cd ../static/ && \
		marked cv-en.md >> ../ext-build/cv-en.html && \
		cd ../ext-build && \
		wkhtmltopdf cv-en.html cv-en.pdf

clean:
	 	rm -fr ../ext-build
