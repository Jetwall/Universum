:orphan:

GitHub Handler command line
---------------------------

GitHub Handler is Universum mode that serves as GitHub Application, helping to perform and report checks on
new commits to a repository. In this mode Universum can create new check runs on GitHub and trigger
builds to perform these checks, parsing accepted payload for required params and passing them to usual
Universum runs in these builds.

For GitHub Handler to work, these parameters are mandatory:

* ``--payload``
* ``--event``
* ``--trigger-url``
* ``--github-app-id``
* ``--github-private-key``

These and other parameters are described below.

.. argparse::
    :module: universum.__main__
    :func: define_arguments
    :prog: python3.7 -m universum
    :path: github-handler
