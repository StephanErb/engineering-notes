READMES = $(sort $(wildcard *.md */*.md))

doc: 
	pandoc $(READMES) -N -V geometry:margin=3cm -V geometry:a4paper -o content.pdf
