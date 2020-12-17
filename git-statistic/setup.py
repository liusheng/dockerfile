#!/usr/bin/env python

PROJECT = 'git-statistic'

VERSION = '0.1'

from setuptools import setup, find_packages

setup(
    name=PROJECT,
    version=VERSION,

    description='BenchMark tools for Hadoop',

    author='Liu Sheng',
    author_email='liusheng2048@gmail.com',

    license='Apache 2.0',

    classifiers=[
        'Programming Language :: Python',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.3',
        'Intended Audience :: Developers',
        'Environment :: Console',
    ],

    platforms=['Any'],

    scripts=[],

    provides=['git-statistic',
              ],
    install_requires=[
        'argparse',
        'cython',
        'numpy',
        'openpyxl',
        'pandas',
        'argparse',
        'datetime',
        'openpyxl',
        'pygithub',
    ],
    namespace_packages=[],
    packages=find_packages(),
    include_package_data=True,
    zip_safe=False,
)
