READMES = $(sort $(wildcard *.md */*.md))

doc: 
	pandoc $(READMES) -N -o content.pdf
