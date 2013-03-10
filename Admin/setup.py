from distutils.core import setup

setup(
	name = 'lc-admin',
	version = '1.0',
	description = 'Tools for dm-lc admins.',
	author = 'Akira Hayakawa',
	author_email = 'ruby.wktk@gmail.com',
	packages = ['lc_admin'],
	scripts = [
		'bin/lc-create',
		'bin/lc-attach',
		'bin/lc-detach',
		'bin/lc-format-cache',
		'bin/lc-resume-cache',
		'bin/lc-admin',
		'bin/lc-daemon',
	],
	install_requires = [
		'python-daemon',
		'argparse',
		'psutil',
	],
)
