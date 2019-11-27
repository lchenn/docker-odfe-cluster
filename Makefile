.PHONY: initialize-development

# Initialize the project development environment.
initialize-development:
	@pip install --upgrade pylint future pre-commit
	@pre-commit install

