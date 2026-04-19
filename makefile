run: 
	sudo ./app.sh run

help:
	@echo "Usage: make [target]"
	@echo "Targets:"
	@echo "  run   - Run the server bootstrap script"
	@echo "  help  - Show this help message"
	./app.sh --help