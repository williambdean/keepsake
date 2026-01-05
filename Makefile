.PHONY: help main tag push-tag

help: ## Show this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

main: ## Compile main.typ and open the PDF
	typst compile main.typ && open main.pdf

tag: ## Create an annotated git tag with version from typst.toml
	@echo "Creating tag: $$(grep '^version' typst.toml | sed 's/.*"\(.*\)"/\1/')"
	@read -p "Are you sure? (y/N): " confirm && [ "$$confirm" = "y" ] || [ "$$confirm" = "Y" ] || (echo "Cancelled." && exit 1)
	git tag -a $$(grep '^version' typst.toml | sed 's/.*"\(.*\)"/\1/') -m "Release $$(grep '^version' typst.toml | sed 's/.*"\(.*\)"/\1/')"

push-tag: ## Push the version tag to origin
	git push origin $$(grep '^version' typst.toml | sed 's/.*"\(.*\)"/\1/')
