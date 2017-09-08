test:
	nosetests -v

clean:
	rm git-working -rf

codecheck:
	flake8 *.py tests --ignore=E501,E123,E128,E121,E124,E711,E402 --show-source

autopep:
	autopep8 *.py tests --ignore=E501,E123,E128,E121,E124,E711,E402 --recursive --in-place

autopepdiff:
	autopep8 *.py tests --ignore=E501,E123,E128,E121,E124,E711,E402 --recursive --diff
