:orphan:

GitHub Handler command line
---------------------------

GitHub Handler is Universum mode that serves as GitHub Application, helping to perform and report checks on
new commits to a repository. In this mode Universum can create new check runs on GitHub and trigger
builds to perform these checks, parsing accepted payload for required params and passing them to usual
Universum runs in these builds.

For GitHub Handler to work, it needs:

* the payload, sent by GitHub in web-hook to GitHub Application, to be passed to ``--payload`` parameter
* event name, sent by GitHub in x-github-event" web-hook header, to be passed to ``--event`` parameter
* an URL to trigger check run build to be passed to ``--trigger-url`` parameter

Additional parameters are described below.

.. argparse::
    :module: universum.__main__
    :func: define_arguments
    :prog: python3.7 -m universum
    :path: github-handler
