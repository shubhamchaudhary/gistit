TEST_FILES = $(wildcard tests/test_*.py)
TESTS = $(subst .py,,$(subst /,.,$(TEST_FILES)))
VERSION = $(shell cat setup.py | grep version | sed -e "s/version=//" -e "s/'//g" -e "s/,//" -e 's/^[ \t]*//')

all.PHONY: nosetests_3 nosetests_2

nosetests_2:
	@echo "Running python2 tests"
	@python2.7 `which nosetests`

nosetests_3:
	@echo "Running python3 tests"
	@python3 `which nosetests`

install:
	@echo "Creating distribution package for version $(VERSION)"
	@echo "-----------------------------------------------"
	python setup.py sdist
	@echo "Installing package using pip"
	@echo "----------------------------"
	pip install --upgrade dist/GistIt-$(VERSION).tar.gz

coverage:
	@coverage run `which nosetests`
	@coverage report

test:
	@- $(foreach TEST,$(TESTS), \
		echo === Running test: $(TEST); \
		python -m $(TEST) $(PYFLAGS); \
		)

test2:
	@- $(foreach TEST,$(TESTS), \
		echo === Running python2 test: $(TEST); \
		python2 -m $(TEST) $(PYFLAGS); \
		)
test3:
	@- $(foreach TEST,$(TESTS), \
		echo === Running python3 test: $(TEST); \
		python3 -m $(TEST) $(PYFLAGS); \
		)
