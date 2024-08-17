all:
	docker build -t localhost/vitasdk-docker:latest .

clean:
	@echo ""
	@echo "To delete the docker image, run:"
	@echo ""
	@echo "    docker image rm localhost/vitasdk-docker:latest"
	@echo ""

.PHONY: all clean
