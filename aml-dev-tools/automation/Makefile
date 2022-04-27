# This is a make file to help with the commands
root:
	# '==Commands=='
	# TODO Finish docs

install_git_hooks:
	cp .hooks/pre-commit ../.git/hooks/

create_virtualenv: install_git_hooks
	virtualenv env

pyenv: create_virtualenv
	(source env/bin/activate &&  pip install -r requirements.txt)

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
