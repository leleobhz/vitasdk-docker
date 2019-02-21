all:
	docker build -t vitasdk-docker .

clean:
	@echo ""
	@echo "To delete the docker image, run:"
	@echo ""
	@echo "    docker image rm vitasdk-docker"
	@echo ""

.PHONY: all clean
