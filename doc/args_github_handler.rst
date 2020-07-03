:orphan:

GitHub Handler command line
---------------------------

GitHub Handler is Universum mode that serves as GitHub Application, helping to perform and report checks on
new commits to a repository. In this mode Universum can create new check runs on GitHub and trigger
builds to perform these checks, parsing accepted payload for required params and passing them to usual
Universum runs in these builds. The following picture represents the event sequence leading to check result
for a commit displayed on GitHub:

*(picture here)*

On this picture numbers depict the following events:

1. User makes a new commit
2. GitHub detects a commit, creates a check suite and sends a web-hook payload to all subscribed entities
   (including GitHub Handler)
3. GitHub Handler checks that conditions (repo name, web-hook event) are applicable and sends to GitHub a
   request to create a new check run
4. GitHub creates a new check run and sends a new web-hook payload about this event
5. GitHub Handler triggers a usual `Universum` run, retrieving all required parameters from GitHub web-hook
   payload and passing them to the build
6. Universum in default mode with ``--report-to-review`` on and ``--vcs-type=github`` uses received parameters
   to report build ('check') start
7. Depending on build result, Universum either reports build success or failure; if some steps were using
   :doc:`Universum analyzers <code_report>`, and any issues are found, they will also be reported in comments

After this, check result can be view directly on GitHub.

.. note::

    GitHub also sends web-hook payloads on other events (such as *'check run completed'*), that are
    currently ignored by GitHub Handler

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
